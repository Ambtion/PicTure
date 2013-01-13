//
//  SCPMenuManager.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "SCPMenuNavigationController.h"
#import "SCPLoginViewController.h"

@protocol SCPMenuDelegate <NSObject>
@optional
- (void)menuDidShow;
- (void)menuDidHide;
@end

@class SCPMenuNavigationController;

@interface SCPMenuManager : NSObject<SCPLoginViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    CGFloat animationDuration;
    int offset;
    BOOL isMenudone;
    NSInteger index;
}
@property (assign, nonatomic) id<SCPMenuDelegate> menuDelegate;
@property (assign, nonatomic) SCPMenuNavigationController *navController;

@property (retain, nonatomic) SCPLoginViewController * homelogin;
@property (retain, nonatomic) SCPLoginViewController * notLogin;
@property (retain, nonatomic) SCPLoginViewController * uLoadLogin;

@property (assign, nonatomic) BOOL isMoving;
@property (assign, nonatomic) BOOL isMenuShowing;
@property (assign, nonatomic) CGFloat menuHeight;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) UIView *ribbon;
@property (strong, nonatomic) UIView *ribbonFake;
@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIView *naviView;

- (void)prepareView;
- (void)viewDidUnload;

- (void)showMenuWithRibbon;
- (void)hideMenuWithRibbon:(BOOL)hideRibbon;

- (void)hideRibbonWithAnimation:(BOOL)animation;
- (void)showRibbonWithAnimation:(BOOL)animation;

- (void)resetMenu;

- (void)menuDidHide;
- (void)menuDidShow;

- (void)restIcon:(NSInteger)sender;

//animationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (void)onAccountClicked:(id)sender;
@end
