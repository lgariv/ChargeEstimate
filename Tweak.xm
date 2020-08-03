#import "ChargeEstimateExtra.h"
#include <IOKit/pwr_mgt/IOPM.h>
#include <IOKit/IOTypes.h>
#include <IOKit/IOReturn.h>
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
@property (assign,getter=isInternal,nonatomic) BOOL internal;                                          //@synthesize internal=_internal - In the implementation block
@end

NSDictionary* getBatteryInfo() {
  CFDictionaryRef matching = IOServiceMatching("IOPMPowerSource");
  io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
  CFMutableDictionaryRef prop = NULL;
  IORegistryEntryCreateCFProperties(service, &prop, NULL, 0);
  CFTypeRef intTimeRemaining;
  intTimeRemaining = IORegistryEntryCreateCFProperty(service, CFSTR("AvgTimeToFull"), NULL, 0);
  NSString *serialNumber = [NSString stringWithString:(__bridge NSString*)intTimeRemaining];
  CFRelease(intTimeRemaining);
  NSLog(@"timeRemaining: %@", serialNumber);
  NSDictionary* dict = (__bridge_transfer NSDictionary*)prop;
  IOObjectRelease(service);
  return dict;
}

%hook UILabel
- (void)setText:(NSString *)arg1 {
  if ([arg1 containsString:@"Charged"]) {
    NSString *original = arg1;
    arg1 = @"FOUND";
    BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
    NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices"); // getter לכל המכשירים

    NSMutableString *newMessage = [NSMutableString new];

    BCBatteryDevice *device;
    for (BCBatteryDevice *batteryDevice in devices) {
      //if ([device isInternal]) {
        device = batteryDevice;
      //}
    }

    //long long deviceCharge = MSHookIvar<long long>(device, "_percentCharge");
    //BOOL deviceCharging = MSHookIvar<BOOL>(device, "_charging");

    //getInfo:
    NSDictionary* batteryInfo = getBatteryInfo();
    NSLog(@"[TESTINGTEST] %@",batteryInfo);
    NSLog(@"[TESTINGTEST] AbsoluteCapacity:%f",[batteryInfo[@"AbsoluteCapacity"] doubleValue]);
    NSLog(@"[TESTINGTEST] NominalChargeCapacity:%f",[batteryInfo[@"NominalChargeCapacity"] doubleValue]);
    NSLog(@"[TESTINGTEST] Amperage:%f",[batteryInfo[@"Amperage"] doubleValue]);
    NSLog(@"[TESTINGTEST] AdapterCurrent:%f",[batteryInfo[@"AdapterDetails"][@"Current"] doubleValue]);

    double max = [batteryInfo[@"NominalChargeCapacity"] doubleValue];
    double amp = [batteryInfo[@"Amperage"] doubleValue];
    //if (amp <= 100) goto getInfo;
    if (amp <= 0) amp = [batteryInfo[@"AdapterDetails"][@"Current"] doubleValue]-200;
    double currentCharge = [batteryInfo[@"AbsoluteCapacity"] doubleValue];
    //double currentCharge = ((deviceCharge*max)/100);
    long long timeRemaining = ((max-currentCharge)/amp)*60;
    NSLog(@"[TESTINGTEST] timeRemaining:%lld",timeRemaining);

    double avgTime = 0;
    if ([batteryInfo[@"AdapterDetails"][@"Watts"] doubleValue] == 5) {
      [newMessage appendString:[NSString stringWithFormat:@"Charging "]]; // מבנה ההודעה
      if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"avgTimeDict"] != nil) {      
        NSMutableDictionary *avgTimeDict = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"avgTimeDict"] mutableCopy];
        //if (avgTimeDict != nil) {
          //if ([avgTimeDict count] == 1) {
            if (currentCharge - [[avgTimeDict allValues][0] doubleValue] >= 20) {
            //if ([[avgTimeDict allValues][0] doubleValue] < currentCharge) {
              double timeToTime = [[NSDate date] timeIntervalSince1970] - [[avgTimeDict allKeys][0] doubleValue];
              double charged = currentCharge - [[avgTimeDict allValues][0] doubleValue];
              double remaining = max - currentCharge;
              avgTime = ((((remaining/charged)*timeToTime)+[[[NSUserDefaults standardUserDefaults] valueForKey:@"avgTime"] doubleValue])/2)/60;
              NSDictionary *newAvgTimeDict = @{[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue] : [NSNumber numberWithDouble:currentCharge]};
              [[NSUserDefaults standardUserDefaults] setObject:newAvgTimeDict forKey:@"avgTimeDict"];
              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:avgTime] forKey:@"avgTime"];
              NSLog(@"[TESTINGTEST] NEW :%f",(remaining/charged)*timeToTime);
              NSLog(@"[TESTINGTEST] NEW avgTime:%f",avgTime);
            } else {
              avgTime = [[[NSUserDefaults standardUserDefaults] valueForKey:@"avgTime"] doubleValue];
            }
          //}
        //}
      } else {
        NSDictionary *newAvgTimeDict = @{[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue] : [NSNumber numberWithDouble:currentCharge]};
        [[NSUserDefaults standardUserDefaults] setObject:newAvgTimeDict forKey:@"avgTimeDict"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:timeRemaining] forKey:@"avgTime"];
        NSLog(@"[TESTINGTEST] NIL avgTime:%f",avgTime);
      }
    } else if ([batteryInfo[@"AdapterDetails"][@"Watts"] doubleValue] >= 5) {
      [newMessage appendString:[NSString stringWithFormat:@"Fast Charging "]]; // מבנה ההודעה
      if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"avgTimeFastDict"] != nil) {      
        NSMutableDictionary *avgTimeFastDict = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"avgTimeFastDict"] mutableCopy];
        //if (avgTimeFastDict != nil) {
          //if ([avgTimeFastDict count] == 1) {
            if (currentCharge - [[avgTimeFastDict allValues][0] doubleValue] >= 20) {
            //if ([[avgTimeFastDict allValues][0] doubleValue] < currentCharge) {
              double timeToTime = [[NSDate date] timeIntervalSince1970] - [[avgTimeFastDict allKeys][0] doubleValue];
              double charged = currentCharge - [[avgTimeFastDict allValues][0] doubleValue];
              double remaining = max - currentCharge;
              avgTime = ((((remaining/charged)*timeToTime)+[[[NSUserDefaults standardUserDefaults] valueForKey:@"avgTimeFast"] doubleValue])/2)/60;
              NSDictionary *newAvgTimeFastDict = @{[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue] : [NSNumber numberWithDouble:currentCharge]};
              [[NSUserDefaults standardUserDefaults] setObject:newAvgTimeFastDict forKey:@"avgTimeFastDict"];
              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:avgTime] forKey:@"avgTimeFast"];
              NSLog(@"[TESTINGTEST] NEW :%f",(remaining/charged)*timeToTime);
              NSLog(@"[TESTINGTEST] NEW avgTime:%f",avgTime);
            } else {
              avgTime = [[[NSUserDefaults standardUserDefaults] valueForKey:@"avgTimeFast"] doubleValue];
            }
          //}
        //}
      } else {
        NSDictionary *newAvgTimeFastDict = @{[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue] : [NSNumber numberWithDouble:currentCharge]};
        [[NSUserDefaults standardUserDefaults] setObject:newAvgTimeFastDict forKey:@"avgTimeFastDict"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:timeRemaining] forKey:@"avgTimeFast"];
        NSLog(@"[TESTINGTEST] NIL avgTime:%f",avgTime);
      }
    }

    if (avgTime != 0) {
      if ([batteryInfo[@"AvgTimeToFull"] doubleValue] != 65535) {
        NSLog(@"[TESTINGTEST] avgTime:%f AvgTimeToFull:%f",avgTime,([batteryInfo[@"AvgTimeToFull"] doubleValue]/600));
        timeRemaining = ((avgTime*2)+(timeRemaining*2)+([batteryInfo[@"AvgTimeToFull"] doubleValue]/600))/5;
      } else {
        NSLog(@"[TESTINGTEST] avgTime:%f",avgTime);
        timeRemaining = ((avgTime*2)+(timeRemaining*2))/4;
      }
    } else if ([batteryInfo[@"AvgTimeToFull"] doubleValue] != 65535) {
      NSLog(@"[TESTINGTEST] AvgTimeToFull:%f",([batteryInfo[@"AvgTimeToFull"] doubleValue]/600));
      timeRemaining = ((timeRemaining*2)+([batteryInfo[@"AvgTimeToFull"] doubleValue]/600))/3;
    }

    //if (currentCharge != 1) {
      if (timeRemaining >= 60) {
        long long timeRemainingHours = timeRemaining/60;
        long long timeRemainingMinutes = timeRemaining-(timeRemainingHours*60);
        if (timeRemainingMinutes == 0)
        [newMessage appendString:[NSString stringWithFormat:@"(%lld hrs until full)", timeRemainingHours]]; // מבנה ההודעה
        else
        [newMessage appendString:[NSString stringWithFormat:@"(%lld hrs, %lld mins until full)", timeRemainingHours, timeRemainingMinutes]]; // מבנה ההודעה
        arg1 = newMessage;
      } else {
        if (timeRemaining <= 1) {
          if (currentCharge <= 1 && currentCharge >= 0.99) {
            [newMessage appendString:[NSString stringWithFormat:@"(almost full)"]]; // מבנה ההודעה
            arg1 = newMessage;
          }
        } else {
          [newMessage appendString:[NSString stringWithFormat:@"(%lld mins until full)", timeRemaining]]; // מבנה ההודעה
          arg1 = newMessage;
        }
      }
    //}
    if ([arg1 containsString:@"Charging"]) %orig(arg1);
    else %orig(original);
  } else {
    %orig;
  }
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
  %orig;
  [[NSNotificationCenter defaultCenter] addObserver:self
  selector:@selector(batteryStateChange:) 
  name:@"UIDeviceBatteryStateDidChangeNotification"
  object:nil];
}

%new
- (void)batteryStateChange:(NSNotification *)notification {
  if ([[UIDevice currentDevice] batteryState] == 2) {
    NSLog(@"[TESTINGTEST] state: Plugged");
  } else if ([[UIDevice currentDevice] batteryState] == 1) {
    NSLog(@"[TESTINGTEST] state: Unplugged");
    /*[[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"avgTimeDict"];
    [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"avgTimeFastDict"];
    [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"avgTime"];
    [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"avgTimeFast"];*/
  }
}
%end