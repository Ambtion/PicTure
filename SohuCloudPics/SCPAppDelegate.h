//
//  SCPAppDelegate.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunctionguideScroll;
@interface SCPAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    FunctionguideScroll * _fgc;
}
@property (strong, nonatomic) UIWindow *window;
- (void)removeFromWindows;
@end
