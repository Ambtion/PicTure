//
//  SCPSetttingViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "SCPSetttingController.h"
#import "SCPSettingRootViewController.h"

@implementation SCPSetttingController

- (id)initWithcontroller:(id)controller
{
    SCPSettingRootViewController * sc = [[[SCPSettingRootViewController alloc] initwithController:controller] autorelease];
    self = [super initWithRootViewController:sc];
    if (self) {
        [self.navigationBar setHidden:YES];
    }
    return self;
}

@end
