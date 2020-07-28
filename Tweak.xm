#import "SlideTextExtra.h"
#import <IOKit/IOKitLib.h>
#import <stdio.h>
#import <spawn.h>
#import <SpringBoard/SpringBoard.h>

@interface BCBatteryDeviceController {
  NSArray* _sortedDevices;		// המכשירים
}

+ (id)sharedInstance;
@end

@interface BCBatteryDevice {
  NSString* _name;		// השם של כל מכשיר
  long long _percentCharge;		// האחוזים של כל מכשיר
  BOOL _wirelesslyCharging; // האם נטען אלחוטית
  BOOL _charging; // האם נטען
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

%group enableTweak
%hook CSTeachableMomentsContainerViewController
- (void)_updateText:(id)arg1 {
    /*if (STtext ){
        arg1 = STtext;
    }*/
    BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
    NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices"); // getter לכל המכשירים

    NSDictionary* batteryInfo = getBatteryInfo();

    NSMutableString *newMessage = [NSMutableString new];

    for (BCBatteryDevice *device in devices) {
      long long deviceCharge = MSHookIvar<long long>(device, "_percentCharge"); //getter בנפרד לאחוזים של כל מכשיר
      BOOL deviceCharging = MSHookIvar<BOOL>(device, "_charging"); //getter בנפרד לאחוזים של כל מכשיר

      if (deviceCharging) {
        static double max = (2362.92/1000)*1000;
        static double amp = (1)*1000;
        double currentcharge = ((deviceCharge*max)/100);
        long long timeRemaining = ((max-currentcharge)/amp)*60;
        if (currentcharge != 1) {
          if (timeRemaining >= 60) {
            long long timeRemainingHours = timeRemaining/60;
            long long timeRemainingMinutes = timeRemaining-(timeRemainingHours*60);
            [newMessage appendString:[NSString stringWithFormat:@"Charging (%lld hrs, %lld mins until full)\n", timeRemainingHours, timeRemainingMinutes]]; // מבנה ההודעה
            arg1 = newMessage;
          } else {
            if (timeRemaining == 0) {
              if (currentcharge == 1) {
                arg1 = STtext;
              } else {
                [newMessage appendString:[NSString stringWithFormat:@"Charging (almost full)\n"]]; // מבנה ההודעה
                arg1 = newMessage;
              }
            } else {
              [newMessage appendString:[NSString stringWithFormat:@"Charging (%lld mins until full)\n", timeRemaining]]; // מבנה ההודעה
              arg1 = newMessage;
            }
          }
          %orig(arg1);
        }
      } else {
        arg1 = STtext;
        %orig(arg1);
      }
    }
}
/*- (void)fadeInImmediately:(BOOL)arg1 completion:(id)arg2 {
  arg1 = YES;
  return %orig;
}
- (void)setVisible:(BOOL)arg1 animated:(BOOL)arg2 {
  arg1 = YES;
  arg2 = NO;
  return %orig;
}*/
-(id)_textPositionAnimationWithDuration:(double)arg1 beginTime:(double)arg2 {
  //arg1 = 0;
  //arg2 = 1;
  return %orig (arg1, arg2);
}
- (id)_textAlphaAnimationWithDuration:(double)arg1 beginTime:(double)arg2{
  arg1 = 1;
  arg2 = 0;
  return %orig (arg1, arg2);
}
%end
%hook CSTeachableMomentsContainerView
/*- (void)setCallToActionLabel:(id)arg1 {
    if (STtext ){
        arg1 = STtext;
    }
    %orig(arg1);
}*/
- (void)setFrame:(CGRect)arg1 {
    arg1 = (CGRectMake(arg1.origin.x, Height, arg1.size.width, arg1.size.height));
    %orig(arg1);
}
%end
%end

%group disableTweak
%hook CSTeachableMomentsContainerViewController
- (void)_updateText:(id)arg1 {
    if ( STtext == nil ) {
        arg1 = @"Swipe up to unlock";
    }
    %orig(arg1);
}
%end
%hook SBDashBoardTeachableMomentsContainerViewController
- (void)_updateText:(id)arg1 {
    if ( STtext == nil ) {
        arg1 = @"Swipe up to unlock";
    }
    %orig(arg1);
}
%end
%end

void Respring() {
  [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.slidetextprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
        if ( STtext == ( [prefs objectForKey:@"STtext"] ? [prefs objectForKey:@"STtext"] : nil ) ) {
            %init(disableTweak);
        } else {
            STtext = ( [prefs objectForKey:@"STtext"] ? [prefs objectForKey:@"STtext"] : STtext );
            %init(enableTweak);
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

%ctor {
    @autoreleasepool {
        changeHeight();
        loadPrefs();
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.slidetextprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)Respring, CFSTR("com.miwix.KamaKeifPrefs/relaunchSpringBoard"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        }
}
