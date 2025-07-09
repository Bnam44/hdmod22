#import "Cbeios.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

// Nên là những gì tôi cho các bạn đều được soạn thảo lại 100% đầy đủ tỷ mỉ Bởi vì tôi yêu quý các bạn. Khi mình thất thế xa cơ hỏi ĐÉO 1 THẰNG NÀO giúp cả, thậm chí còn bị khinh thường, Anh em tự lực mà cố gắng nhá. Cố lên.
// Nếu bạn Tôn Trọng @Cbeios
@implementation Cbeios

- (void)ThanhThanh:(char *)appName
                     bundleID:(char *)bundleID
                   appVersion:(char *)appVersion
                  deviceModel:(char *)deviceModel {
    // Lấy thông tin App
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    strncpy(appName, [name UTF8String], 256);
    NSLog(@"App Name: %@", name);

    // Lấy thông tin BundleID
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    strncpy(bundleID, [bundle UTF8String], 256);
    NSLog(@"Bundle ID: %@", bundle);

    // Lấy thông tin Version
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    strncpy(appVersion, [version UTF8String], 256);
    NSLog(@"App Version: %@", version);

    // Lấy thông tin Model
    NSString *model = [self deviceModelName];
    strncpy(deviceModel, [model UTF8String], 256);
    NSLog(@"Device Model: %@", model);
}

- (NSString *)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *modelCode = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    
// Khai báo một từ điển (dictionary) dùng để ánh xạ mã model với tên thiết bị
NSDictionary *modelMap = @{
    // Mã thiết bị : Tên thiết bị
    @"i386"      : @"Simulator",                        // Mã "i386" đại diện cho giả lập (Simulator).
    @"x86_64"    : @"Simulator",                        // Mã "x86_64" cũng đại diện cho giả lập.
    @"iPod1,1"   : @"iPod Touch (Original)",           // Mã "iPod1,1" là iPod Touch (phiên bản gốc).
    @"iPod2,1"   : @"iPod Touch (2nd generation)",     // Mã "iPod2,1" là iPod Touch (thế hệ thứ 2).
    @"iPod3,1"   : @"iPod Touch (3rd generation)",     // Mã "iPod3,1" là iPod Touch (thế hệ thứ 3).
    @"iPod4,1"   : @"iPod Touch (4th generation)",     // Mã "iPod4,1" là iPod Touch (thế hệ thứ 4).
    @"iPod5,1"   : @"iPod Touch (5th generation)",     // Mã "iPod5,1" là iPod Touch (thế hệ thứ 5).
    @"iPod7,1"   : @"iPod Touch (6th generation)",     // Mã "iPod7,1" là iPod Touch (thế hệ thứ 6).
    @"iPod9,1"   : @"iPod Touch (7th generation)",     // Mã "iPod9,1" là iPod Touch (thế hệ thứ 7).
    @"iPhone1,1" : @"iPhone (Original)",               // Mã "iPhone1,1" là iPhone (phiên bản gốc).
    @"iPhone1,2" : @"iPhone 3G",                        // Mã "iPhone1,2" là iPhone 3G.
    @"iPhone2,1" : @"iPhone 3GS",                       // Mã "iPhone2,1" là iPhone 3GS.
    @"iPhone3,1" : @"iPhone 4 (GSM)",                   // Mã "iPhone3,1" là iPhone 4 (phiên bản GSM).
    @"iPhone3,2" : @"iPhone 4 (GSM Rev A)",             // Mã "iPhone3,2" là iPhone 4 (GSM Rev A).
    @"iPhone3,3" : @"iPhone 4 (CDMA)",                  // Mã "iPhone3,3" là iPhone 4 (CDMA).
    @"iPhone4,1" : @"iPhone 4S",                        // Mã "iPhone4,1" là iPhone 4S.
    @"iPhone5,1" : @"iPhone 5 (GSM)",                   // Mã "iPhone5,1" là iPhone 5 (GSM).
    @"iPhone5,2" : @"iPhone 5 (Global)",                // Mã "iPhone5,2" là iPhone 5 (toàn cầu).
    @"iPhone5,3" : @"iPhone 5c (GSM)",                  // Mã "iPhone5,3" là iPhone 5c (GSM).
    @"iPhone5,4" : @"iPhone 5c (Global)",               // Mã "iPhone5,4" là iPhone 5c (toàn cầu).
    @"iPhone6,1" : @"iPhone 5s (GSM)",                  // Mã "iPhone6,1" là iPhone 5s (GSM).
    @"iPhone6,2" : @"iPhone 5s (Global)",               // Mã "iPhone6,2" là iPhone 5s (toàn cầu).
    @"iPhone7,1" : @"iPhone 6 Plus",                    // Mã "iPhone7,1" là iPhone 6 Plus.
    @"iPhone7,2" : @"iPhone 6",                         // Mã "iPhone7,2" là iPhone 6.
    @"iPhone8,1" : @"iPhone 6s",                        // Mã "iPhone8,1" là iPhone 6s.
    @"iPhone8,2" : @"iPhone 6s Plus",                   // Mã "iPhone8,2" là iPhone 6s Plus.
    @"iPhone8,4" : @"iPhone SE (1st generation)",       // Mã "iPhone8,4" là iPhone SE (thế hệ thứ 1).
    @"iPhone9,1" : @"iPhone 7",                         // Mã "iPhone9,1" là iPhone 7.
    @"iPhone9,2" : @"iPhone 7 Plus",                    // Mã "iPhone9,2" là iPhone 7 Plus.
    @"iPhone9,3" : @"iPhone 7",                         // Mã "iPhone9,3" là iPhone 7.
    @"iPhone9,4" : @"iPhone 7 Plus",                    // Mã "iPhone9,4" là iPhone 7 Plus.
    @"iPhone10,1" : @"iPhone 8",                        // Mã "iPhone10,1" là iPhone 8.
    @"iPhone10,2" : @"iPhone 8 Plus",                   // Mã "iPhone10,2" là iPhone 8 Plus.
    @"iPhone10,3" : @"iPhone X",                        // Mã "iPhone10,3" là iPhone X.
    @"iPhone10,4" : @"iPhone 8",                        // Mã "iPhone10,4" là iPhone 8.
    @"iPhone10,5" : @"iPhone 8 Plus",                   // Mã "iPhone10,5" là iPhone 8 Plus.
    @"iPhone10,6" : @"iPhone X",                        // Mã "iPhone10,6" là iPhone X.
    @"iPhone11,2" : @"iPhone XS",                       // Mã "iPhone11,2" là iPhone XS.
    @"iPhone11,4" : @"iPhone XS Max",                   // Mã "iPhone11,4" là iPhone XS Max.
    @"iPhone11,6" : @"iPhone XS Max (China)",           // Mã "iPhone11,6" là iPhone XS Max (phiên bản Trung Quốc).
    @"iPhone11,8" : @"iPhone XR",                       // Mã "iPhone11,8" là iPhone XR.
    @"iPhone12,1" : @"iPhone 11",                       // Mã "iPhone12,1" là iPhone 11.
    @"iPhone12,3" : @"iPhone 11 Pro",                   // Mã "iPhone12,3" là iPhone 11 Pro.
    @"iPhone12,5" : @"iPhone 11 Pro Max",               // Mã "iPhone12,5" là iPhone 11 Pro Max.
    @"iPhone12,8" : @"iPhone SE (2nd generation)",     // Mã "iPhone12,8" là iPhone SE (thế hệ thứ 2).
    @"iPhone13,1" : @"iPhone 12 mini",                  // Mã "iPhone13,1" là iPhone 12 mini.
    @"iPhone13,2" : @"iPhone 12",                       // Mã "iPhone13,2" là iPhone 12.
    @"iPhone13,3" : @"iPhone 12 Pro",                   // Mã "iPhone13,3" là iPhone 12 Pro.
    @"iPhone13,4" : @"iPhone 12 Pro Max",               // Mã "iPhone13,4" là iPhone 12 Pro Max.
    @"iPhone14,4" : @"iPhone 13 mini",                  // Mã "iPhone14,4" là iPhone 13 mini.
    @"iPhone14,5" : @"iPhone 13",                       // Mã "iPhone14,5" là iPhone 13.
    @"iPhone14,2" : @"iPhone 13 Pro",                   // Mã "iPhone14,2" là iPhone 13 Pro.
    @"iPhone14,3" : @"iPhone 13 Pro Max",               // Mã "iPhone14,3" là iPhone 13 Pro Max.
    @"iPhone14,6" : @"iPhone SE (3rd generation)",     // Mã "iPhone14,6" là iPhone SE (thế hệ thứ 3).
    @"iPhone14,7" : @"iPhone 14",                       // Mã "iPhone14,7" là iPhone 14.
    @"iPhone14,8" : @"iPhone 14 Plus",                  // Mã "iPhone14,8" là iPhone 14 Plus.
    @"iPhone15,2" : @"iPhone 14 Pro",                   // Mã "iPhone15,2" là iPhone 14 Pro.
    @"iPhone15,3" : @"iPhone 14 Pro Max",               // Mã "iPhone15,3" là iPhone 14 Pro Max.
    @"iPad1,1"   : @"iPad (Original)",                  // Mã "iPad1,1" là iPad (phiên bản gốc).
    @"iPad2,1"   : @"iPad 2 (Wi-Fi)",                   // Mã "iPad2,1" là iPad 2 (phiên bản Wi-Fi).
    @"iPad2,2"   : @"iPad 2 (GSM)",                      // Mã "iPad2,2" là iPad 2 (GSM).
    @"iPad2,3"   : @"iPad 2 (CDMA)",                     // Mã "iPad2,3" là iPad 2 (CDMA).
    @"iPad2,4"   : @"iPad 2 (Wi-Fi Rev A)",             // Mã "iPad2,4" là iPad 2 (Wi-Fi Rev A).
    @"iPad3,1"   : @"iPad (3rd generation) (Wi-Fi)",   // Mã "iPad3,1" là iPad (thế hệ thứ 3) (Wi-Fi).
    @"iPad3,2"   : @"iPad (3rd generation) (CDMA)",    // Mã "iPad3,2" là iPad (thế hệ thứ 3) (CDMA).
    @"iPad3,3"   : @"iPad (3rd generation) (Global)",   // Mã "iPad3,3" là iPad (thế hệ thứ 3) (toàn cầu).
    @"iPad3,4"   : @"iPad (4th generation) (Wi-Fi)",   // Mã "iPad3,4" là iPad (thế hệ thứ 4) (Wi-Fi).
    @"iPad3,5"   : @"iPad (4th generation) (CDMA)",     // Mã "iPad3,5" là iPad (thế hệ thứ 4) (CDMA).
    @"iPad3,6"   : @"iPad (4th generation) (Global)",   // Mã "iPad3,6" là iPad (thế hệ thứ 4) (toàn cầu).
    @"iPad6,11"  : @"iPad (5th generation) (Wi-Fi)",    // Mã "iPad6,11" là iPad (thế hệ thứ 5) (Wi-Fi).
    @"iPad6,12"  : @"iPad (5th generation) (Global)",   // Mã "iPad6,12" là iPad (thế hệ thứ 5) (toàn cầu).
    @"iPad7,5"   : @"iPad (6th generation) (Wi-Fi)",    // Mã "iPad7,5" là iPad (thế hệ thứ 6) (Wi-Fi).
    @"iPad7,6"   : @"iPad (6th generation) (Global)",    // Mã "iPad7,6" là iPad (thế hệ thứ 6) (toàn cầu).
    @"iPad7,11"  : @"iPad (7th generation) (Wi-Fi)",    // Mã "iPad7,11" là iPad (thế hệ thứ 7) (Wi-Fi).
    @"iPad7,12"  : @"iPad (7th generation) (Global)",    // Mã "iPad7,12" là iPad (thế hệ thứ 7) (toàn cầu).
    @"iPad11,6"  : @"iPad (8th generation) (Wi-Fi)",    // Mã "iPad11,6" là iPad (thế hệ thứ 8) (Wi-Fi).
    @"iPad11,7"  : @"iPad (8th generation) (Global)",    // Mã "iPad11,7" là iPad (thế hệ thứ 8) (toàn cầu).
    @"iPad12,1"  : @"iPad (9th generation) (Wi-Fi)",    // Mã "iPad12,1" là iPad (thế hệ thứ 9) (Wi-Fi).
    @"iPad12,2"  : @"iPad (9th generation) (Global)",    // Mã "iPad12,2" là iPad (thế hệ thứ 9) (toàn cầu).
    @"iPad2,5"   : @"iPad mini (Wi-Fi)",                 // Mã "iPad2,5" là iPad mini (Wi-Fi).
    @"iPad2,6"   : @"iPad mini (Global)",                // Mã "iPad2,6" là iPad mini (toàn cầu).
    @"iPad2,7"   : @"iPad mini (CDMA)",                  // Mã "iPad2,7" là iPad mini (CDMA).
    @"iPad4,4"   : @"iPad mini 2 (Wi-Fi)",               // Mã "iPad4,4" là iPad mini 2 (Wi-Fi).
    @"iPad4,5"   : @"iPad mini 2 (Global)",              // Mã "iPad4,5" là iPad mini 2 (toàn cầu).
    @"iPad4,6"   : @"iPad mini 2 (CDMA)",                // Mã "iPad4,6" là iPad mini 2 (CDMA).
    @"iPad4,7"   : @"iPad mini 3 (Wi-Fi)",               // Mã "iPad4,7" là iPad mini 3 (Wi-Fi).
    @"iPad4,8"   : @"iPad mini 3 (Global)",              // Mã "iPad4,8" là iPad mini 3 (toàn cầu).
    @"iPad4,9"   : @"iPad mini 3 (CDMA)",                // Mã "iPad4,9" là iPad mini 3 (CDMA).
    @"iPad5,1"   : @"iPad mini 4 (Wi-Fi)",               // Mã "iPad5,1" là iPad mini 4 (Wi-Fi).
    @"iPad5,2"   : @"iPad mini 4 (Global)",              // Mã "iPad5,2" là iPad mini 4 (toàn cầu).
    @"iPad11,1"  : @"iPad mini (5th generation) (Wi-Fi)", // Mã "iPad11,1" là iPad mini (thế hệ thứ 5) (Wi-Fi).
    @"iPad11,2"  : @"iPad mini (5th generation) (Global)", // Mã "iPad11,2" là iPad mini (thế hệ thứ 5) (toàn cầu).
    @"iPad14,1"  : @"iPad mini (6th generation) (Wi-Fi)", // Mã "iPad14,1" là iPad mini (thế hệ thứ 6) (Wi-Fi).
    @"iPad14,2"  : @"iPad mini (6th generation) (Global)", // Mã "iPad14,2" là iPad mini (thế hệ thứ 6) (toàn cầu).
    @"iPad6,3"   : @"iPad Pro (9.7 inch) (Wi-Fi)",      // Mã "iPad6,3" là iPad Pro (9.7 inch) (Wi-Fi).
    @"iPad6,4"   : @"iPad Pro (9.7 inch) (Global)",     // Mã "iPad6,4" là iPad Pro (9.7 inch) (toàn cầu).
    @"iPad6,7"   : @"iPad Pro (12.9 inch) (Wi-Fi)",     // Mã "iPad6,7" là iPad Pro (12.9 inch) (Wi-Fi).
    @"iPad6,8"   : @"iPad Pro (12.9 inch) (Global)",    // Mã "iPad6,8" là iPad Pro (12.9 inch) (toàn cầu).
    @"iPad7,3"   : @"iPad Pro (10.5 inch) (Wi-Fi)",     // Mã "iPad7,3" là iPad Pro (10.5 inch) (Wi-Fi).
    @"iPad7,4"   : @"iPad Pro (10.5 inch) (Global)",    // Mã "iPad7,4" là iPad Pro (10.5 inch) (toàn cầu).
    @"iPad8,1"   : @"iPad Pro (11 inch) (Wi-Fi)",       // Mã "iPad8,1" là iPad Pro (11 inch) (Wi-Fi).
    @"iPad8,2"   : @"iPad Pro (11 inch) (Global)",      // Mã "iPad8,2" là iPad Pro (11 inch) (toàn cầu).
    @"iPad8,3"   : @"iPad Pro (11 inch) (Wi-Fi Rev B)", // Mã "iPad8,3" là iPad Pro (11 inch) (Wi-Fi Rev B).
    @"iPad8,4"   : @"iPad Pro (11 inch) (Global Rev B)", // Mã "iPad8,4" là iPad Pro (11 inch) (toàn cầu Rev B).
    @"iPad8,5"   : @"iPad Pro (12.9 inch) (Wi-Fi Rev B)", // Mã "iPad8,5" là iPad Pro (12.9 inch) (Wi-Fi Rev B).
    @"iPad8,6"   : @"iPad Pro (12.9 inch) (Global Rev B)", // Mã "iPad8,6" là iPad Pro (12.9 inch) (toàn cầu Rev B).
    @"iPad8,7"   : @"iPad Pro (12.9 inch) (Wi-Fi Rev C)", // Mã "iPad8,7" là iPad Pro (12.9 inch) (Wi-Fi Rev C).
    @"iPad8,8"   : @"iPad Pro (12.9 inch) (Global Rev C)", // Mã "iPad8,8" là iPad Pro (12.9 inch) (toàn cầu Rev C).
    @"iPad8,9"   : @"iPad Pro (11 inch) (Wi-Fi Rev C)",  // Mã "iPad8,9" là iPad Pro (11 inch) (Wi-Fi Rev C).
    @"iPad8,10"  : @"iPad Pro (11 inch) (Global Rev C)", // Mã "iPad8,10" là iPad Pro (11 inch) (toàn cầu Rev C).
    @"iPad8,11"  : @"iPad Pro (12.9 inch) (Wi-Fi Rev D)", // Mã "iPad8,11" là iPad Pro (12.9 inch) (Wi-Fi Rev D).
    @"iPad8,12"  : @"iPad Pro (12.9 inch) (Global Rev D)", // Mã "iPad8,12" là iPad Pro (12.9 inch) (toàn cầu Rev D).
    @"iPad13,4"  : @"iPad Pro (11 inch) (Wi-Fi Rev D)", // Mã "iPad13,4" là iPad Pro (11 inch) (Wi-Fi Rev D).
    @"iPad13,5"  : @"iPad Pro (11 inch) (Global Rev D)", // Mã "iPad13,5" là iPad Pro (11 inch) (toàn cầu Rev D).
    @"iPad13,6"  : @"iPad Pro (12.9 inch) (Wi-Fi Rev E)", // Mã "iPad13,6" là iPad Pro (12.9 inch) (Wi-Fi Rev E).
    @"iPad13,7"  : @"iPad Pro (12.9 inch) (Global Rev E)", // Mã "iPad13,7" là iPad Pro (12.9 inch) (toàn cầu Rev E).
    @"iPad7,1"   : @"iPad Pro (12.9 inch 2nd generation) (Wi-Fi)", // Mã "iPad7,1" là iPad Pro (12.9 inch thế hệ thứ 2) (Wi-Fi).
    @"iPad7,2"   : @"iPad Pro (12.9 inch 2nd generation) (Global)", // Mã "iPad7,2" là iPad Pro (12.9 inch thế hệ thứ 2) (toàn cầu).
    @"iPad11,3"  : @"iPad Air (3rd generation) (Wi-Fi)", // Mã "iPad11,3" là iPad Air (thế hệ thứ 3) (Wi-Fi).
    @"iPad11,4"  : @"iPad Air (3rd generation) (Global)", // Mã "iPad11,4" là iPad Air (thế hệ thứ 3) (toàn cầu).
    @"iPad13,1"  : @"iPad Air (4th generation) (Wi-Fi)", // Mã "iPad13,1" là iPad Air (thế hệ thứ 4) (Wi-Fi).
    @"iPad13,2"  : @"iPad Air (4th generation) (Global)", // Mã "iPad13,2" là iPad Air (thế hệ thứ 4) (toàn cầu).
    @"iPad13,16" : @"iPad Air (5th generation) (Wi-Fi)", // Mã "iPad13,16" là iPad Air (thế hệ thứ 5) (Wi-Fi).
    @"iPad13,17" : @"iPad Air (5th generation) (Global)" // Mã "iPad13,17" là iPad Air (thế hệ thứ 5) (toàn cầu).
};

// Lấy tên thiết bị dựa trên mã model được cung cấp (modelCode).
NSString *deviceName = modelMap[modelCode]; 
if (deviceName) { // Nếu tên thiết bị tồn tại trong từ điển modelMap
    return deviceName; // Trả về tên thiết bị.
}

return modelCode;  // Không thỏa mãn Điều kiện, Trả về mã model
}





@end
