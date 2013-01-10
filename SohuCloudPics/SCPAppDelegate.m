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


void customedExceptionHandler(NSException *exception)
{
#ifdef DEBUG
    NSLog(@"CRASH name: %@\n", [exception name]);
    NSLog(@"CRASH reason: %@\n", [exception reason]);
    NSLog(@"StackTrace: %@\n", [exception callStackSymbols]);
//    NSMutableArray * array =[NSMutableArray arrayWithArray:[exception callStackSymbols]];
//    [array insertObject:[exception reason] atIndex:0];
//    [array insertObject:[exception name] atIndex:0];
//    [array writeToFile:DEBUGFILE atomically:YES];
#else
    
#endif
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
////    NSFileManager * manager = [NSFileManager defaultManager];
//    if (1) {
//        
//        SKPSMTPMessage *forgotPassword = [[SKPSMTPMessage alloc] init];
//        [forgotPassword setFromEmail:@"mtpcwireless@gmail.com"];  // Change to your email address
//        [forgotPassword setToEmail:@"634808912@qq.com"]; // Load this, or have user enter this
//        [forgotPassword setRelayHost:@"smtp.gmail.com"];
//        [forgotPassword setRequiresAuth:YES]; // GMail requires this
//        [forgotPassword setLogin:@"mtpcwireless@gmail.com"]; // Same as the "setFromEmail:" email
//        [forgotPassword setPass:@"QQqq123456"]; // Password for the Gmail account that you are sending from
//        [forgotPassword setSubject:@"Forgot Password: My App"]; // Change this to change the subject of the email
//        [forgotPassword setWantsSecure:YES]; // Gmail Requires this
//        [forgotPassword setDelegate:self]; // Required
//        
//        NSString *newpassword = @"helloworld";
//        NSString *message = [NSString stringWithFormat:@"Your password has been successfully reset. Your new password: %@", newpassword];
//        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain", kSKPSMTPPartContentTypeKey, message, kSKPSMTPPartMessageKey, @"8bit" , kSKPSMTPPartContentTransferEncodingKey, nil];
//        [forgotPassword setParts:[NSArray arrayWithObjects:plainPart, nil]];
//        [forgotPassword send];
//    }
}
//- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
//{
//    NSLog(@"MMM %@",error);
//}
//- (void)messageSent:(SKPSMTPMessage *)message
//{
//    NSLog(@"%@",message);
//}

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
