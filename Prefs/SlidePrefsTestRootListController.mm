//
//  SlidePrefsTestPreferencesListController.mm
//  SlidePrefsTest
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> 01/16/2018
//  © CP Digital Darkroom <admin@miwix.com> All rights reserved.
//

#import "SlidePrefsTestPreferences.h"
#include <spawn.h>

extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

@interface SlidePrefsTestRootListController : PSListController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *dynamicSpecs;

@end

@implementation SlidePrefsTestRootListController

- (instancetype)init {
  if(self = [super init]) {
    [self createDynamicSpecs];
  }
  return self;
}

- (void)createDynamicSpecs {
  PSSpecifier *specifier;
  _dynamicSpecs = [NSMutableArray new];

  specifier = groupSpecifier(@"");
  [_dynamicSpecs addObject:specifier];

  specifier = textEditCellWithName(@"Emojis:");
  setClassForSpec(NSClassFromString(@"SlidePrefsTestEditableTextCell"));
  [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
  setDefaultForSpec(@"");
  setPlaceholderForSpec(@"Your Favorite Emojis");
  setKeyForSpec(@"CustomEmojis");
  [_dynamicSpecs addObject:specifier];
}

-(id)specifiers {
  if(_specifiers == nil) {

    NSMutableArray *mutableSpecifiers = [NSMutableArray new];
    PSSpecifier *specifier;

    specifier = groupSpecifier(@"");
    [mutableSpecifiers addObject:specifier];

    specifier = subtitleSwitchCellWithName(@"Enabled");
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    setKeyForSpec(@"SlidePrefsTestEnabled");
    [mutableSpecifiers addObject:specifier];

    specifier = groupSpecifier(@"Shown Emojis");
    [mutableSpecifiers addObject:specifier];

    specifier = segmentCellWithName(@"Shown Emojis");
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    [specifier setValues:@[@(1), @(2)] titles:@[@"Recent", @"Custom"]];
    setDefaultForSpec(@1);
		setKeyForSpec(@"EmojiSource");
		[mutableSpecifiers addObject:specifier];

    int sourceType = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("EmojiSource"), CFSTR("com.miwix.SlidePrefsTest"))) intValue];
    if(sourceType == 2) {
      for(PSSpecifier *sp in _dynamicSpecs) {
        [mutableSpecifiers addObject:sp];
      }
    }

    specifier = groupSpecifier(@"Locations");
    setFooterForSpec(@"Bottom Bar: The default SlidePrefsTest implementation for iPhone X or devices who have enabled the iPhone X layout. \n\nReplace Predictive Bar: Replaces the text prediction bar with SlidePrefsTest, useful for non-iPhone X devices");
    [mutableSpecifiers addObject:specifier];

    specifier = subtitleSwitchCellWithName(@"Bottom Bar");
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    setKeyForSpec(@"SlidePrefsTestBottomEnabled");
    [mutableSpecifiers addObject:specifier];

    specifier = subtitleSwitchCellWithName(@"Replace Predictive Bar");
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    setKeyForSpec(@"SlidePrefsTestPredictiveEnabled");
    [mutableSpecifiers addObject:specifier];

    specifier = groupSpecifier(@"Haptic Feedback");
    [mutableSpecifiers addObject:specifier];

    specifier = [PSSpecifier preferenceSpecifierNamed:@"Feedback Type" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NSClassFromString(@"SlidePrefsTestListItemsController") cell:PSLinkListCell edit:nil];
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    setKeyForSpec(@"SlidePrefsTestFeedbackType");
    [specifier setValues:[self activationTypeValues] titles:[self activationTypeTitles] shortTitles:[self activationTypeShortTitles]];
    [mutableSpecifiers addObject:specifier];

    specifier = groupSpecifier(@"Layout");
    setFooterForSpec(@"Scroll direction only applies to the Predictive Bar location.");
    [mutableSpecifiers addObject:specifier];

    specifier = [PSSpecifier preferenceSpecifierNamed:@"Scroll Direction" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NSClassFromString(@"SlidePrefsTestListItemsController") cell:PSLinkListCell edit:nil];
    [specifier setProperty:@"com.miwix.SlidePrefsTest" forKey:@"defaults"];
    setKeyForSpec(@"SlidePrefsTestScrollDirection");
    [specifier setValues:[self scrollDirectionValues] titles:[self scrollDirectionTitles] shortTitles:[self scrollDirectionShortTitles]];
    [mutableSpecifiers addObject:specifier];

    specifier = groupSpecifier(@"");
    setFooterForSpec(@"A respring is required to fully apply setting changes");
    [mutableSpecifiers addObject:specifier];

    specifier = buttonCellWithName(@"Respring");
    specifier->action = @selector(respring);
    [mutableSpecifiers addObject:specifier];

    specifier = groupSpecifier(@"Support");
    setFooterForSpec(@"Having Trouble? Get in touch and I'll help when I can");
    [mutableSpecifiers addObject:specifier];

    specifier = buttonCellWithName(@"Email Support");
    specifier->action = @selector(presentSupportMailController:);
    [mutableSpecifiers addObject:specifier];

    _specifiers = [mutableSpecifiers copy];
  }

  return _specifiers;
}

- (NSArray *)activationTypeShortTitles {
  return @[
    @"None",
    @"Extra Light",
    @"Light",
    @"Medium",
    @"Strong",
    @"Strong 2",
    @"Strong 3"
  ];
}

- (NSArray *)activationTypeTitles {
  return @[
    @"None",
    @"Extra Light",
    @"Light",
    @"Medium",
    @"Strong",
    @"Strong 2",
    @"Strong 3"
  ];
}

- (NSArray *)activationTypeValues {
  return @[
    @7, @1, @2, @3, @4, @5, @6
  ];
}

- (NSArray *)scrollDirectionShortTitles {
  return [self scrollDirectionTitles];
}

- (NSArray *)scrollDirectionTitles {
  return @[
    @"Horizontal", @"Vertical"
  ];
}

- (NSArray *)scrollDirectionValues {
  return @[
    @(UICollectionViewScrollDirectionHorizontal), @(UICollectionViewScrollDirectionVertical)
  ];
}

- (void)presentSupportMailController:(PSSpecifier *)spec {

  MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
  [composeViewController setSubject:@"SlidePrefsTest Support"];
  [composeViewController setToRecipients:[NSArray arrayWithObjects:@"CP Digital Darkroom <tweaks@miwix.support>", nil]];

  NSString *product = nil, *version = nil, *build = nil;
  product = (__bridge_transfer NSString *)MGCopyAnswer(kMGProductType);
  version = (__bridge_transfer NSString *)MGCopyAnswer(kMGProductVersion);
  build = (__bridge_transfer NSString *)MGCopyAnswer(kMGBuildVersion);

  [composeViewController setMessageBody:[NSString stringWithFormat:@"\n\nCurrent Device: %@, iOS %@ (%@)", product, version, build] isHTML:NO];

  NSTask *task = [[NSTask alloc] init];
  [task setLaunchPath: @"/bin/sh"];
  [task setArguments:@[@"-c", [NSString stringWithFormat:@"dpkg -l"]]];

  NSPipe *pipe = [NSPipe pipe];
  [task setStandardOutput:pipe];
  [task launch];

  NSData *data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];

  [composeViewController addAttachmentData:data mimeType:@"text/plain" fileName:@"dpkgl.txt"];

  [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
  composeViewController.mailComposeDelegate = self;

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated: YES completion: nil];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

  [super setPreferenceValue:value specifier:specifier];

  NSDictionary *properties = specifier.properties;
  NSString *key = properties[@"key"];

  if([key isEqualToString:@"EmojiSource"]) {
    BOOL shouldShow = [value intValue] == 2;
    [self shouldShowCustomEmojiSpecifiers:shouldShow];
  }

  int feedbackType = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("SlidePrefsTestFeedbackType"), CFSTR("com.miwix.SlidePrefsTest"))) intValue];
  BOOL bottom = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("SlidePrefsTestBottomEnabled"), CFSTR("com.miwix.SlidePrefsTest"))) boolValue];
  BOOL enabled = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("SlidePrefsTestEnabled"), CFSTR("com.miwix.SlidePrefsTest"))) boolValue];
  BOOL predictive = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("SlidePrefsTestPredictiveEnabled"), CFSTR("com.miwix.SlidePrefsTest"))) boolValue];

  NSDictionary *dictionary = @{
    @"feedbackType": @(feedbackType),
    @"bottom": @(bottom),
    @"enabled": @(enabled),
    @"predictive": @(predictive)
  };
  CFNotificationCenterPostNotification(
    CFNotificationCenterGetDistributedCenter(),
    CFSTR("com.miwix.SlidePrefsTest.settings"),
    nil, (__bridge CFDictionaryRef)dictionary, true);
}

- (void)shouldShowCustomEmojiSpecifiers:(BOOL)show {
  if(show) {
    [self insertContiguousSpecifiers:_dynamicSpecs afterSpecifierID:@"EmojiSource" animated:YES];
  } else {
    [self removeContiguousSpecifiers:_dynamicSpecs animated:YES];
  }
}

- (void)respring {
  pid_t pid;
  int status;
  const char* args[] = {"killall", "-9", "backboardd", NULL};
  posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
  waitpid(pid, &status, WEXITED);
}

@end
