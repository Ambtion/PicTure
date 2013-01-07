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
#import "SCPNavigationController.h"
#import "SCPMenuNavigationController.h"
#import "SCPLoginViewController.h"
#import "SCPExplorerController.h"
#import "SCPAlert_DetailView.h"
#import "FunctionguideScroll.h"

#import "ASIFormDataRequest.h"

void customedExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH name: %@\n", [exception name]);
    NSLog(@"CRASH reason: %@\n", [exception reason]);
    NSLog(@"StackTrace: %@\n", [exception callStackSymbols]);
}


@implementation SCPAppDelegate
@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [_fgc release];
    [super dealloc];
    
}
- (void)pragramerSetting
{
    NSSetUncaughtExceptionHandler(customedExceptionHandler);
    [self removeCache];
}
- (void)removeCache
{
    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [dic  objectForKey: @"CFBundleIdentifier"];
    NSUserDefaults *appUserDefaults = [[[NSUserDefaults alloc] init] autorelease];
    NSLog(@"Start dumping userDefaults for %@", bundleId);
    NSDictionary * cacheDic = [appUserDefaults persistentDomainForName: bundleId];
    NSLog(@"%@",[cacheDic allKeys]);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * _use_id = nil;
    NSString * _use_token = nil;
    NSNumber * GuideViewShowed = nil;
    NSNumber * FunctionShowed = nil;
    //read
    if ([defaults objectForKey:@"__USER_ID__"])
        _use_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"__USER_ID__"]];
    if ([defaults objectForKey:@"__USER_TOKEN__"])
        _use_token = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"__USER_TOKEN__"]];
    if ([defaults objectForKey:@"GuideViewShowed"])
        GuideViewShowed = [[defaults objectForKey:@"GuideViewShowed"] copy];
    if ([defaults objectForKey:@"FunctionShowed"])
        FunctionShowed = [[defaults objectForKey:@"FunctionShowed"] copy];
    
    //remove
    for (NSString * str in [cacheDic allKeys])
        [defaults removeObjectForKey:str];
    if (_use_id)
        [defaults setObject:_use_id forKey:@"__USER_ID__"];
    if (_use_token)
        [defaults setObject:_use_token forKey:@"__USER_TOKEN__"];
    if (GuideViewShowed)
        [defaults setObject:GuideViewShowed forKey:@"GuideViewShowed"];
    if (FunctionShowed)
        [defaults setObject:FunctionShowed forKey:@"FunctionShowed"];
    [defaults synchronize];
    NSDictionary * cacheDic_c = [appUserDefaults persistentDomainForName: bundleId];
    NSLog(@"cache_c %@",[cacheDic_c allKeys]);

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self pragramerSetting];
    [UIApplication sharedApplication].statusBarHidden = YES;
    SCPMainTabController *mainTab = [[SCPMainTabController alloc] initWithNibName:nil bundle:NULL];
    SCPMenuNavigationController *nav = [[SCPMenuNavigationController alloc] initWithRootViewController:mainTab];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    [self showfunctionGuide];
    [mainTab release];
    [nav release];
    return YES;
}

- (void)showfunctionGuide
{
    NSNumber * num  = [[NSUserDefaults standardUserDefaults] objectForKey:@"FunctionShowed"];
    if (!num ||![num boolValue]) {
        _fgc = [[FunctionguideScroll alloc] init];
        [_window addSubview:_fgc.view];
    }
}

- (void)removeFromWindows
{
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [_fgc.view removeFromSuperview];
    animation.delegate = self;
    [self.window.layer addAnimation:animation forKey:@"KO"];
    [_fgc release];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.window.layer removeAnimationForKey:@"KO"];
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
