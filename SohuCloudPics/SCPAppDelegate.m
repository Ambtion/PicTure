//
//  SCPAppDelegate.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "SCPMainTabController.h"
#import "SCPFirstIntroController.h"
#import "SCPMenuNavigationController.h"
#import "SCPLoginViewController.h"
#import "SCPPlazeController.h"
#import "SCPAlert_DetailView.h"
#import "FunctionGuideController.h"
#import "SCPGuideView.h"
#import "SCPGuideViewExchange.h"
#import "AccountSystemRequset.h"
#import "MobClick.h"
#import "UMAppKey.h"

@implementation SCPAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_functionGuideController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	/* The following statements are used for umeng statistic */
    
	[MobClick startWithAppkey:UM_APP_KEY];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    
    SCPMainTabController * mainTab = [[SCPMainTabController alloc] initThenSetAllChildContrllers];
    SCPMenuNavigationController * nav = [[SCPMenuNavigationController alloc] initWithRootViewController:mainTab];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    [mainTab release];
    [nav release];
    
	[self showPalzaGuideView];
    [self showFunctionGuideView];
    return YES;
}

- (void)showPalzaGuideView
{
    NSNumber * isShowed = [[NSUserDefaults standardUserDefaults] objectForKey:@"GuideViewShowed"];
    if (!isShowed || ![isShowed boolValue]) {
        SCPGuideView * view = [[[SCPGuideView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        if ([[UIScreen mainScreen] bounds].size.height > 480) {
            view.image = [UIImage imageNamed:@"exporeGuideIos6_2.png"];
        }else{
            view.image = [UIImage imageNamed:@"exporeGuide.png"];
        }
        [view show];
    }
}

#pragma mark - FunctionGuideView

- (void)showFunctionGuideView
{
    NSNumber * isShowed  = [[NSUserDefaults standardUserDefaults] objectForKey:FUNCTIONSHOWED];
    if (!isShowed ||![isShowed boolValue]) {
        _functionGuideController = [[FunctionGuideController alloc] init];
        _functionGuideController.delegate = self;
        [_window addSubview:_functionGuideController.view];
        [SCPGuideViewExchange exchageViewForwindow];
    }
}

#pragma mark functionDelegate

- (void)functionGuideController:(FunctionGuideController *)anController clickUserButton:(UIButton *)button
{
    [self removeSubViews:anController.view];
    [anController release];
}

- (void)removeSubViews:(UIView *)subViews
{
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [subViews removeFromSuperview];
    animation.delegate = self;
    [self.window.layer addAnimation:animation forKey:@"FadeAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.window.layer removeAnimationForKey:@"FadeAnimation"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
