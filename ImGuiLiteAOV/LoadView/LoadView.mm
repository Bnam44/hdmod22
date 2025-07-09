#import <UIKit/UIKit.h>
#include "Includes.h"
#import "menuIcon.h"
#import "Image/imagepoong.h"
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^


@interface MenuLoad()
@property (nonatomic, strong) ImGuiDrawView *vna;
@property (nonatomic, assign) BOOL isPaidBlockExecuted; // Biến theo dõi paidBlock đã được thực thi hay chưa
//property (nonatomic, strong) LDVQuang *apiKey; // Lưu trữ instance của LDVQuang
- (ImGuiDrawView*) GetImGuiView;
@end

static NSString *const kBaseTxtDownloadURL = @"https://gist.githubusercontent.com/Bnam44/8db40c22fb187ebd8154c8f79bc69ce7/raw/gistfile1.txt"; // Link RAW không SHA

static MenuLoad *extraInfo;

UIButton* InvisibleMenuButton;
UIButton* VisibleMenuButton;
MenuInteraction* menuTouchView;
UITextField* hideRecordTextfield;
UIView* hideRecordView;
ImVec2 menuPos, menuSize;
bool StreamerMode = false;//!;!;

@interface MenuInteraction()
@end

@implementation MenuInteraction

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[extraInfo GetImGuiView] updateIOWithTouchEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[extraInfo GetImGuiView] updateIOWithTouchEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[extraInfo GetImGuiView] updateIOWithTouchEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[extraInfo GetImGuiView] updateIOWithTouchEvent:event];
}

@end

@implementation MenuLoad

- (ImGuiDrawView*) GetImGuiView
{
    return _vna;
}

#pragma mark - Hàm bắt đầu
- (void)startDownloadAndCheckTxt {
    [self deleteOldTxtIfExistsWithCompletion:^{
        [self downloadTxtFileFromURL:kBaseTxtDownloadURL completion:^(NSString *filePath) {
            if (filePath) {
                [self readTxtFileAndCheckContent:filePath];
            }
        }];
    }];
}

#pragma mark - Tạo URL có timestamp chống cache
- (NSString *)urlWithNoCache:(NSString *)urlString {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *finalUrl = [NSString stringWithFormat:@"%@?t=%.0f", urlString, timeStamp];
    return finalUrl;
}

#pragma mark - Xóa file txt cũ
- (void)deleteOldTxtIfExistsWithCompletion:(void(^)(void))completion {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"ano_tmp/config.xml"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"[ERROR] Không xóa được file cũ: %@", error.localizedDescription);
        } else {
            NSLog(@"[INFO] Đã xóa file cũ: %@", filePath);
        }
    } else {
        NSLog(@"[INFO] Không có file cũ để xóa.");
    }
    
    if (completion) {
        completion();
    }
}

#pragma mark - Tải file txt mới
- (void)downloadTxtFileFromURL:(NSString *)urlString completion:(void(^)(NSString *filePath))completion {
    NSString *noCacheUrl = [self urlWithNoCache:urlString];
    NSURL *url = [NSURL URLWithString:noCacheUrl];
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error || !location) {
            NSLog(@"[ERROR] Lỗi tải file: %@", error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *destinationPath = [docPath stringByAppendingPathComponent:@"ano_tmp/config.xml"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *moveError = nil;
        [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&moveError];
        
        if (moveError) {
            NSLog(@"[ERROR] Lỗi ghi file: %@", moveError.localizedDescription);
            completion(nil);
        } else {
            NSLog(@"[INFO] Đã lưu file txt tại: %@", destinationPath);
            completion(destinationPath);
        }
    }];
    
    [downloadTask resume];
}

#pragma mark - Đọc file txt và xử lý Mode / Pass / BT / Link
- (void)readTxtFileAndCheckContent:(NSString *)filePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"[ERROR] File không tồn tại: %@", filePath);
        return;
    }
    
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error || !content) {
        NSLog(@"[ERROR] Lỗi đọc file: %@", error.localizedDescription);
        return;
    }
    
    NSLog(@"[READ] Nội dung file đã tải: %@", content);
    
    BOOL isMode1 = [content containsString:@"Mode_1"];
    BOOL isMode2 = [content containsString:@"Mode_2"];
    BOOL isMode3 = [content containsString:@"Mode_3"];
    
    NSMutableArray *passList = [NSMutableArray array];
    __block NSString *btMessage = @"Cảnh báo từ hệ thống!";
    __block NSString *linkURL = nil;

    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmed hasPrefix:@"Pass ="]) {
            NSString *passValue = [trimmed stringByReplacingOccurrencesOfString:@"Pass =" withString:@""];
            NSArray *passes = [passValue componentsSeparatedByString:@"/"];
            for (NSString *p in passes) {
                NSString *cleanPass = [p stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (cleanPass.length > 0) {
                    [passList addObject:cleanPass];
                }
            }
        } else if ([trimmed hasPrefix:@"BT ="]) {
            NSString *btValue = [trimmed stringByReplacingOccurrencesOfString:@"BT =" withString:@""];
            NSString *cleanBT = [btValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (cleanBT.length > 0) {
                btMessage = cleanBT;
            }
        } else if ([trimmed hasPrefix:@"Link ="]) {
            NSString *linkValue = [trimmed stringByReplacingOccurrencesOfString:@"Link =" withString:@""];
            NSString *cleanLink = [linkValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (cleanLink.length > 0) {
                linkURL = cleanLink;
            }
        }
    }

if (isMode1) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:btMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *contactAction = [UIAlertAction actionWithTitle:@"Liên Hệ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (linkURL && linkURL.length > 0) {
                NSURL *url = [NSURL URLWithString:linkURL];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    exit(0);
                });
            } else {
                // Nếu không có Link, vẫn thoát app
                exit(0);
            }
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        
        [alert addAction:contactAction];
        [alert addAction:okAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
    else if (isMode2) {
        NSLog(@"[INFO] Mode_2: Vào thẳng menu.");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTapGes];
        });
    }
    else if (isMode3) {
        if (passList.count == 0) {
            NSLog(@"[ERROR] Mode_3 nhưng không có Pass.");
            return;
        }
        
        NSString *savedKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedKey"];
        if (savedKey) {
            if ([passList containsObject:savedKey]) {
                NSLog(@"[INFO] Đã có Key lưu sẵn, vào thẳng menu.");
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *savedKeyAlert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"🔑 Key Đã Tự Lưu 🇻🇳\n🎉Chúc AE Chơi Game Vui Vẻ 😋!" preferredStyle:UIAlertControllerStyleAlert];
                [savedKeyAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self initTapGes];
                  }]];
                  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:savedKeyAlert animated:YES completion:nil];
                 });
                return;
            } else {
                NSLog(@"[WARNING] Key lưu cũ không còn hợp lệ, xoá.");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPasswordPromptWithPassList:passList expectedLink:linkURL];
        });
    }
    else {
        NSLog(@"[ERROR] Không có Mode hợp lệ trong file.");
    }
}

#pragma mark - Hiện nhập Key với 2 nút: Xác Nhận và Lấy Key

- (void)showPasswordPromptWithPassList:(NSArray *)passList expectedLink:(NSString *)expectedLink {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Xác Thực" message:@"Nhập Key để xác nhận" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Nhập Key...";
        textField.secureTextEntry = NO;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Xác Nhận" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *inputKey = alert.textFields.firstObject.text;
        BOOL isKeyValid = [passList containsObject:inputKey];
        
        if (isKeyValid) {
            NSLog(@"[SUCCESS] Key đúng.");

            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Thành Công" message:@"Xác thực thành công!" preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:inputKey forKey:@"SavedKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self initTapGes];
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:successAlert animated:YES completion:nil];
            
        } else {
            NSLog(@"[ERROR] Sai Key.");

            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Lỗi" message:@"Sai Key, vui lòng thử lại!" preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPasswordPromptWithPassList:passList expectedLink:expectedLink];
                });
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *getKeyAction = [UIAlertAction actionWithTitle:@"Lấy Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (expectedLink && expectedLink.length > 0) {
            NSURL *url = [NSURL URLWithString:expectedLink];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPasswordPromptWithPassList:passList expectedLink:expectedLink];
        });
    }];
    
    [alert addAction:getKeyAction];
    [alert addAction:confirmAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info)
{   
    timer(3) {
        extraInfo = [MenuLoad new]; 
        //[extraInfo initTapGes]; 
        [extraInfo startDownloadAndCheckTxt];
    });
}


__attribute__((constructor)) static void initialize()
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDrop);
}

-(void)initTapGes
{
    UIView* mainView = [UIApplication sharedApplication].windows[0].rootViewController.view;
    hideRecordTextfield = [[UITextField alloc] init];
    hideRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    [hideRecordView setBackgroundColor:[UIColor clearColor]];
    [hideRecordView setUserInteractionEnabled:YES];
    hideRecordTextfield.secureTextEntry = true;
    [hideRecordView addSubview:hideRecordTextfield];
    CALayer *layer = hideRecordTextfield.layer;
    if ([layer.sublayers.firstObject.delegate isKindOfClass:[UIView class]]) {
        hideRecordView = (UIView *)layer.sublayers.firstObject.delegate;
    } else {
        hideRecordView = nil;
    }

    [[UIApplication sharedApplication].keyWindow addSubview:hideRecordView];
    
    if (!_vna) {
         ImGuiDrawView *vc = [[ImGuiDrawView alloc] init];
         _vna = vc;
    }
     
    [ImGuiDrawView showChange:false];
    [hideRecordView addSubview:_vna.view];

    menuTouchView = [[MenuInteraction alloc] initWithFrame:mainView.frame];
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:menuTouchView];

    NSData* data = [[NSData alloc] initWithBase64EncodedString:ConHoPong options:0];
    UIImage* menuIconImage = [UIImage imageWithData:data];

    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/sLMadWB.png"]];
    //UIImage *menuIconImage = [UIImage imageWithData:data];


    InvisibleMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    InvisibleMenuButton.frame = CGRectMake(5, 5, 40, 30);
    InvisibleMenuButton.backgroundColor = [UIColor clearColor];
    [InvisibleMenuButton addTarget:self action:@selector(buttonDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu:)];
    [InvisibleMenuButton addGestureRecognizer:tapGestureRecognizer];
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:InvisibleMenuButton];
    
    VisibleMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    VisibleMenuButton.frame = CGRectMake(5, 5, 40, 30);
    VisibleMenuButton.backgroundColor = [UIColor clearColor];
    VisibleMenuButton.layer.cornerRadius = VisibleMenuButton.frame.size.width * 0.5f;
    [VisibleMenuButton setBackgroundImage:menuIconImage forState:UIControlStateNormal];
    // Thêm viền màu trắng
    //VisibleMenuButton.layer.borderColor = [UIColor whiteColor].CGColor; // Màu viền
    //VisibleMenuButton.layer.borderWidth = 1.0f; // Độ dày viền
    // Cắt phần thừa ngoài đường viền tròn
    VisibleMenuButton.clipsToBounds = YES;
    [hideRecordView addSubview:VisibleMenuButton];
    // Đảm bảo rằng VisibleMenuButton không thể bị kéo di chuyển
    [VisibleMenuButton setUserInteractionEnabled:NO];
    // Gọi hàm layoutSubviews để đảm bảo tất cả các thuộc tính được thiết lập chính xác
    [VisibleMenuButton layoutIfNeeded];
}

-(void)showMenu:(UITapGestureRecognizer *)tapGestureRecognizer {
    if(tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [ImGuiDrawView showChange:![ImGuiDrawView isMenuShowing]];
    }
}

- (void)buttonDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];

    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;

    button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);

    VisibleMenuButton.center = button.center;
    VisibleMenuButton.frame = button.frame;

}

@end