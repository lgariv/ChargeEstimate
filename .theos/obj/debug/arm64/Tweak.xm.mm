#line 1 "Tweak.xm"
#import "SlideTextExtra.h"
#import <IOKit/IOKitLib.h>
#import <stdio.h>
#import <spawn.h>
#import <SpringBoard/SpringBoard.h>

@interface BCBatteryDeviceController {
  NSArray* _sortedDevices;		
}

+ (id)sharedInstance;
@end

@interface BCBatteryDevice {
  NSString* _name;		
  long long _percentCharge;		
  BOOL _wirelesslyCharging; 
  BOOL _charging; 
}
@end

static BOOL TweakisEnabled = YES;
static NSString* STtext = @"Swipe up to unlock";
static int Height = -33;

NSDictionary* getBatteryInfo()
{
  CFDictionaryRef matching = IOServiceMatching("IOPMPowerSource");
  io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
  CFMutableDictionaryRef prop = NULL;
  IORegistryEntryCreateCFProperties(service, &prop, NULL, 0);
  NSDictionary* dict = (__bridge_transfer NSDictionary*)prop;
  IOObjectRelease(service);
  return dict;
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CSTeachableMomentsContainerView; @class SBDashBoardTeachableMomentsContainerViewController; @class BCBatteryDeviceController; @class CSTeachableMomentsContainerViewController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$BCBatteryDeviceController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("BCBatteryDeviceController"); } return _klass; }
#line 37 "Tweak.xm"
static void (*_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_updateText$)(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$)(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, double, double); static id _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, double, double); static id (*_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$)(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, double, double); static id _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, double, double); static void (*_logos_orig$enableTweak$CSTeachableMomentsContainerView$setFrame$)(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerView* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$enableTweak$CSTeachableMomentsContainerView$setFrame$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerView* _LOGOS_SELF_CONST, SEL, CGRect); 

static void _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    


    BCBatteryDeviceController *bcb = [_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance];
    NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices"); 

    NSDictionary* batteryInfo = getBatteryInfo();

    NSMutableString *newMessage = [NSMutableString new];

    for (BCBatteryDevice *device in devices) {
      long long deviceCharge = MSHookIvar<long long>(device, "_percentCharge"); 
      BOOL deviceCharging = MSHookIvar<BOOL>(device, "_charging"); 

      if (deviceCharging) {
        static double max = (2362.92/1000)*1000;
        static double amp = (1)*1000;
        double currentcharge = ((deviceCharge*max)/100);
        long long timeRemaining = ((max-currentcharge)/amp)*60;
        if (currentcharge != 1) {
          if (timeRemaining >= 60) {
            long long timeRemainingHours = timeRemaining/60;
            long long timeRemainingMinutes = timeRemaining-(timeRemainingHours*60);
            [newMessage appendString:[NSString stringWithFormat:@"Charging (%lld hrs, %lld mins until full)\n", timeRemainingHours, timeRemainingMinutes]]; 
            arg1 = newMessage;
          } else {
            if (timeRemaining == 0) {
              if (currentcharge == 1) {
                arg1 = STtext;
              } else {
                [newMessage appendString:[NSString stringWithFormat:@"Charging (almost full)\n"]]; 
                arg1 = newMessage;
              }
            } else {
              [newMessage appendString:[NSString stringWithFormat:@"Charging (%lld mins until full)\n", timeRemaining]]; 
              arg1 = newMessage;
            }
          }
          _logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_updateText$(self, _cmd, arg1);
        }
      } else {
        arg1 = STtext;
        _logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_updateText$(self, _cmd, arg1);
      }
    }
}









static id _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1, double arg2) {
  
  
  return _logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$(self, _cmd, arg1, arg2);
}
static id _logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1, double arg2){
  arg1 = 1;
  arg2 = 0;
  return _logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$(self, _cmd, arg1, arg2);
}








static void _logos_method$enableTweak$CSTeachableMomentsContainerView$setFrame$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1) {
    arg1 = (CGRectMake(arg1.origin.x, Height, arg1.size.width, arg1.size.height));
    _logos_orig$enableTweak$CSTeachableMomentsContainerView$setFrame$(self, _cmd, arg1);
}



static void (*_logos_orig$disableTweak$CSTeachableMomentsContainerViewController$_updateText$)(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$disableTweak$CSTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$)(_LOGOS_SELF_TYPE_NORMAL SBDashBoardTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL SBDashBoardTeachableMomentsContainerViewController* _LOGOS_SELF_CONST, SEL, id); 

static void _logos_method$disableTweak$CSTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL CSTeachableMomentsContainerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    if ( STtext == nil ) {
        arg1 = @"Swipe up to unlock";
    }
    _logos_orig$disableTweak$CSTeachableMomentsContainerViewController$_updateText$(self, _cmd, arg1);
}


static void _logos_method$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$(_LOGOS_SELF_TYPE_NORMAL SBDashBoardTeachableMomentsContainerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    if ( STtext == nil ) {
        arg1 = @"Swipe up to unlock";
    }
    _logos_orig$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$(self, _cmd, arg1);
}



void Respring() {
  [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.slidetextprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
        if ( STtext == ( [prefs objectForKey:@"STtext"] ? [prefs objectForKey:@"STtext"] : nil ) ) {
            {Class _logos_class$disableTweak$CSTeachableMomentsContainerViewController = objc_getClass("CSTeachableMomentsContainerViewController"); { MSHookMessageEx(_logos_class$disableTweak$CSTeachableMomentsContainerViewController, @selector(_updateText:), (IMP)&_logos_method$disableTweak$CSTeachableMomentsContainerViewController$_updateText$, (IMP*)&_logos_orig$disableTweak$CSTeachableMomentsContainerViewController$_updateText$);}Class _logos_class$disableTweak$SBDashBoardTeachableMomentsContainerViewController = objc_getClass("SBDashBoardTeachableMomentsContainerViewController"); { MSHookMessageEx(_logos_class$disableTweak$SBDashBoardTeachableMomentsContainerViewController, @selector(_updateText:), (IMP)&_logos_method$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$, (IMP*)&_logos_orig$disableTweak$SBDashBoardTeachableMomentsContainerViewController$_updateText$);}}
        } else {
            STtext = ( [prefs objectForKey:@"STtext"] ? [prefs objectForKey:@"STtext"] : STtext );
            {Class _logos_class$enableTweak$CSTeachableMomentsContainerViewController = objc_getClass("CSTeachableMomentsContainerViewController"); { MSHookMessageEx(_logos_class$enableTweak$CSTeachableMomentsContainerViewController, @selector(_updateText:), (IMP)&_logos_method$enableTweak$CSTeachableMomentsContainerViewController$_updateText$, (IMP*)&_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_updateText$);}{ MSHookMessageEx(_logos_class$enableTweak$CSTeachableMomentsContainerViewController, @selector(_textPositionAnimationWithDuration:beginTime:), (IMP)&_logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$, (IMP*)&_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textPositionAnimationWithDuration$beginTime$);}{ MSHookMessageEx(_logos_class$enableTweak$CSTeachableMomentsContainerViewController, @selector(_textAlphaAnimationWithDuration:beginTime:), (IMP)&_logos_method$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$, (IMP*)&_logos_orig$enableTweak$CSTeachableMomentsContainerViewController$_textAlphaAnimationWithDuration$beginTime$);}Class _logos_class$enableTweak$CSTeachableMomentsContainerView = objc_getClass("CSTeachableMomentsContainerView"); { MSHookMessageEx(_logos_class$enableTweak$CSTeachableMomentsContainerView, @selector(setFrame:), (IMP)&_logos_method$enableTweak$CSTeachableMomentsContainerView$setFrame$, (IMP*)&_logos_orig$enableTweak$CSTeachableMomentsContainerView$setFrame$);}}
        }
    }
}

static void changeHeight()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.slidetextprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
      if ( Height == ( [prefs objectForKey:@"Height"] ? [[prefs objectForKey:@"Height"] intValue] : Height ) ) {
      } else {
        Height = ( [prefs objectForKey:@"HeightSlider"] ? [[prefs objectForKey:@"HeightSlider"] intValue] : Height );
      }
    }
}

static __attribute__((constructor)) void _logosLocalCtor_5a0f9afd(int __unused argc, char __unused **argv, char __unused **envp) {
    @autoreleasepool {
        changeHeight();
        loadPrefs();
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.slidetextprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)Respring, CFSTR("com.miwix.KamaKeifPrefs/relaunchSpringBoard"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        }
}
