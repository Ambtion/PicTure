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

#import "ASIHTTPRequest.h"

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
//    NSLog(@"home::%@",NSHomeDirectory());
//    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
//    NSString *bundleId = [dic  objectForKey: @"CFBundleIdentifier"];
//    NSUserDefaults *appUserDefaults = [[NSUserDefaults alloc] init];
//    NSLog(@"Start dumping userDefaults for %@", bundleId);
//    NSLog(@"userDefaults dump: %@", [appUserDefaults persistentDomainForName: bundleId]);
//    NSLog(@"Finished dumping userDefaults for %@", bundleId);
//    [appUserDefaults release];
    NSSetUncaughtExceptionHandler(customedExceptionHandler);

}
- (void)test
{
//    NSString * str = [NSString stringWithFormat:@"%@/photos/%@?owner_id=%@];
//    NSLog(@"%@",str);
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
//    [request setTimeOutSeconds:5.f];
//    [request setCompletionBlock:^{
////        [self photoDetailrequestFinished:request];
//    }];
//    [request setFailedBlock:^{
//        if ([_delegate respondsToSelector:@selector(requestFailed:)]) {
//            [_delegate performSelector:@selector(requestFailed:) withObject:@"连接失败"];
//        }
//    }];
//    [request startAsynchronous];

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
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"FunctionShowed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
