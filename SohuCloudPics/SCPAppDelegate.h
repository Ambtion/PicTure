//
//  SCPAppDelegate.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionGuideController.h"

@class FunctionGuideController;

@interface SCPAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate,UIWebViewDelegate,FunctionGuideControllerDelegate>
{
    FunctionGuideController * _functionGuideController;
}
@property (strong, nonatomic) UIWindow *window;

@end
