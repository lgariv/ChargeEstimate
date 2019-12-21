#include "STPRootListController.h"
#import <SpringBoard/SpringBoard.h>

@implementation STPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)save
{
    [self.view endEditing:YES];
}

@end
