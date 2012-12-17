//
//  SCPNavigationController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// Describtion : only for customer navigation pop push transtion
#import "SCPNavigationController.h"

#import <QuartzCore/QuartzCore.h>


@implementation SCPNavigationController

//@synthesize movableTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (animated) {
    //        CATransition *anime = [CATransition animation];
    //        [anime setDuration:0.1];
    //        [anime setType:kCATransitionPush];
    //        [anime setSubtype:kCATransitionFromRight];
    //        anime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        [self.view.layer addAnimation:anime forKey:@"push"];
    //    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //    if (animated) {
    //        CATransition *anime = [CATransition animation];
    //        [anime setDuration:0.1];
    //        [anime setType:kCATransitionPush];
    //        [anime setSubtype:kCATransitionFromLeft];
    //        anime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        [self.view.layer addAnimation:anime forKey:@"push"];
    //    }
    return [super popViewControllerAnimated:animated];
}

@end
