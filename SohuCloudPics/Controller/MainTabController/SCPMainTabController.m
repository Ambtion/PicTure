//
//  SCPMainTabController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPMainTabController.h"

#import <QuartzCore/QuartzCore.h>

#import "SCPMainFeedController.h"
#import "SCPPlazeController.h"
#import "SCPFirstIntroController.h"
#import "SCPMenuNavigationController.h"

#import "SCPMyHomeViewController.h"

@implementation SCPMainTabController

@synthesize slideRecognizerL2R;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        slideRecognizerL2R = [[SCPHorizontalGestureRecognizer alloc] initWithTarget:self action:@selector(switchTab)];
        slideRecognizerL2R.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:slideRecognizerL2R];
        self.delegate = self;
        
        //注意使用addChildViewController 会引起Two-stage rotation animation is deprecated. This application should use the smoother single-stage animation.
        //Plaze
        SCPPlazeController * plaze= [[SCPPlazeController alloc] initWithNibName:nil bundle:nil];
        // MainFeed
        SCPMainFeedController * mainFeed = [[SCPMainFeedController alloc] initWithNibName:nil bundle:nil];
        self.viewControllers = [NSArray arrayWithObjects:plaze,mainFeed,nil];
        [plaze release];
        [mainFeed release];
    }
    return self;
}
- (void)makeTabBarHidden:(BOOL)hide
{
    if ( [self.view.subviews count] < 2 )
        return;
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    if ( hide )
    {
        contentView.frame = self.view.bounds;
    }
    else
    {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }  
    
    self.tabBar.hidden = hide;  
}
- (void)dealloc
{
    self.slideRecognizerL2R = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeTabBarHidden:YES];
}
#pragma mark -
#pragma mark TabDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    CATransition *anime = [CATransition animation];
    [anime setDuration:0.8];
    [anime setType:kCATransitionMoveIn];
    [anime setSubtype:kCATransitionFromLeft];
    [tabBarController.view.layer addAnimation:anime forKey:@"push"];
    return YES;
}

#pragma mark -
#pragma show&hide tabbar with animation
- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    for (UIView *view in tabbarcontroller.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    for (UIView *view in tabbarcontroller.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    [UIView commitAnimations];
}

#pragma mark -
#pragma gesture recognizer

- (void)switchTab
{
    NSInteger index = (self.selectedIndex + 1) % [self.childViewControllers count];
    [self switchToindex:index];
}
- (void)switchToindex:(NSInteger)index
{
    
    SCPMenuManager *menu = ((SCPMenuNavigationController *) self.navigationController).menuManager;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self setSelectedIndex:index];
    [UIView commitAnimations];
    if (index == 0) {
        [menu restIcon:3];
    }
    if (index == 1) {
        [menu restIcon:2];
    }
    [menu hideMenuWithRibbon:NO];
}
@end
