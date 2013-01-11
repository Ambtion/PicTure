//
//  SCPAppDelegate.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEBUG 1
#define DEBUGFILE [NSHomeDirectory() stringByAppendingPathComponent:@"Debug"]

@class FunctionguideScroll;

@interface SCPAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate,UIWebViewDelegate>
{
    FunctionguideScroll * _fgc;
}
@property (strong, nonatomic) UIWindow *window;
- (void)removeFromWindows;
@end
