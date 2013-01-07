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
    SCPSettingRootViewController * sc = [[SCPSettingRootViewController alloc] initwithController:controller];
    self = [super initWithRootViewController:sc];
    if (self) {
        
    }
    [sc release];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setHidden:YES];
}

@end
