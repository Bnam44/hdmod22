#import <Foundation/Foundation.h>

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

@interface Cbeios : NSObject

- (void)ThanhThanh:(char *)appName
                     bundleID:(char *)bundleID
                   appVersion:(char *)appVersion
                  deviceModel:(char *)deviceModel;


@end