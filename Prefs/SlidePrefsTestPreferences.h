//
//  BarmojiPreferences.h
//  Barmoji
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> 01/16/2018
//  © CP Digital Darkroom <admin@cpdigitaldarkroom.com> All rights reserved.
//

#import "SlidePrefsTestListItemsController.h"

#import <MessageUI/MessageUI.h>
#import <MobileGestalt/MobileGestalt.h>
#import <Preferences/PSListController.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIKit.h>
#import <version.h>

@interface NSTask : NSObject

- (id)init;
- (void)launch;
- (void)setArguments:(id)arg1;
- (void)setLaunchPath:(id)arg1;
- (void)setStandardOutput:(id)arg1;
- (id)standardOutput;

@end

#define MAIN_ICON_PATH               @"/Library/PreferenceBundles/Kairos2.bundle/images/Kairos2.png"
#define HEADER_ICON               @"/Library/PreferenceBundles/Kairos2.bundle/images/headerLogo.png"

#define buttonCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NULL cell:PSButtonCell edit:Nil]
#define groupSpecifier(name) [PSSpecifier groupSpecifierWithName:name]
#define subtitleSwitchCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSSwitchCell edit:Nil]
#define switchCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSSwitchCell edit:Nil]
#define textCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NULL cell:PSStaticTextCell edit:Nil]
#define textEditCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSEditTextCell edit:Nil]
#define segmentCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSSegmentCell edit:Nil]
#define setDefaultForSpec(sDefault) [specifier setProperty:sDefault forKey:@"default"]
#define setClassForSpec(className) [specifier setProperty:className forKey:@"cellClass"]
#define setPlaceholderForSpec(placeholder) [specifier setProperty:placeholder forKey:@"placeholder"]

#define setKeyForSpec(key) [specifier setProperty:key forKey:@"key"]
#define setFooterForSpec(footer) [specifier setProperty:footer forKey:@"footerText"]
