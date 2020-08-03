#import <UIKit/UIKit.h>

@interface UIApplication (DM)
- (BOOL)isSuspended;
- (void)terminateWithSuccess;
@end

@interface CSFixedFooterView : UIView
- (id)initWithFrame:(CGRect)arg1;
@end

@interface SBApplication : NSObject
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
- (void)applicationService:(id)arg1 suspendApplicationWithBundleIdentifier:(id)arg2;
@end