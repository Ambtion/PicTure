//
//  SCPNavigationController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// Navigation的转场动画预留接口....

#import "SCPNavigationController.h"

#import <QuartzCore/QuartzCore.h>

@implementation SCPNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

@end
