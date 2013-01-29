//
//  SCPMenuNavigationController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// 定义彩带的View,动作,跳转
//...
// 彩带拉出视图,3D旋转,彩带按钮跳转

#import <UIKit/UIKit.h>
#import "SCPMenuManager.h"
#import "SCPNavigationController.h"

@class SCPMenuManager;
@interface SCPMenuNavigationController : SCPNavigationController
{
    BOOL  _disableRibbon;
}

@property (strong, nonatomic) UIView *myNavigationBar;
@property (strong, nonatomic) SCPMenuManager *menuManager;
@property (strong, nonatomic) UIView * menuView;
@property (strong, nonatomic) UIView *ribbonView;

@property (assign, nonatomic) BOOL needShow;
@property (assign, nonatomic) BOOL needHide;
@property (assign, nonatomic) BOOL disableMenu;
@property (assign, nonatomic) BOOL disableRibbon;

- (void)setDisableMenu:(BOOL)disable;

// delegate call
- (void)showMenu;
- (void)hideMenu;

// animationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (void)resetMenu;
@end
