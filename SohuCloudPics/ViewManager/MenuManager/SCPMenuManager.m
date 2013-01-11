//
//  SCPMenuManager.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPMenuManager.h"

#import <QuartzCore/QuartzCore.h>
//上页
#import "SCPMainTabController.h"
#import "AlbumControllerManager.h"
#import "SCPMyHomeViewController.h"
#import "SCPSetttingController.h"
#import "SCPLoginPridictive.h"
#import "SCPLoginViewController.h"
#import "SCPMainFeedController.h"
//下页
#import "SCPExplorerController.h"
#import "CameraViewController.h"
#import "NoticeViewController.h"



#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

static NSString *menuNormal[6] = {
    @"menu_upload.png", @"menu_me.png", @"menu_feed.png",
    @"menu_explore.png", @"menu_camera.png", @"menu_alert.png",
};

static NSString *menuPress[6] = {
    @"menu_upload_press.png", @"menu_me_press.png", @"menu_feed_press.png",
    @"menu_explore_press.png", @"menu_camera_press.png", @"menu_alert_press.png",
};


@implementation SCPMenuManager
@synthesize homelogin;
@synthesize notLogin;
@synthesize uLoadLogin;

@synthesize menuArray;
@synthesize ribbon;
@synthesize ribbonFake;
@synthesize menuHeight;
@synthesize isMoving;
@synthesize isMenuShowing;
@synthesize menuDelegate;
@synthesize coverView;
@synthesize rootView;
@synthesize naviView;

@synthesize navController;

- (id)init
{
    self = [super init];
    if (self) {
        menuHeight = 50.0;
        animationDuration = 0.3f;
        offset = 0;
        isMenudone = NO;
    }
    return self;
}

- (void)dealloc
{
    self.ribbonFake = nil;
    self.ribbon = nil;
    self.coverView = nil;
    self.menuArray = nil;
    self.homelogin = nil;
    self.notLogin = nil;
    self.uLoadLogin = nil;
    [super dealloc];
}

// view prepare view 
- (void)prepareView
{
    UIImage *click;
    UIImage *idle;
    UIButton *btn;
    UIView *menuBar;
    
    isMenuShowing = FALSE;
    isMoving = FALSE;
    menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // bar1
    menuBar = [[UIView alloc] initWithFrame:CGRectMake(-offset, 0, 320, menuHeight)];
    menuBar.backgroundColor = [UIColor whiteColor];
    // batch
    idle = [UIImage imageNamed:@"menu_upload.png"];
    click = [UIImage imageNamed:@"menu_upload_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset, 0, 106, menuHeight);
    btn.tag = 100;
    [btn setBackgroundImage:idle forState:UIControlStateNormal];
    [btn setBackgroundImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onBatchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    // account
    idle = [UIImage imageNamed:@"menu_me.png"];
    click = [UIImage imageNamed:@"menu_me_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset + 106, 0, 106, menuHeight);
    btn.tag = 101;
    [btn setBackgroundImage:idle forState:UIControlStateNormal];
    [btn setBackgroundImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onAccountClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    // followed
    idle = [UIImage imageNamed:@"menu_feed.png"];
    click = [UIImage imageNamed:@"menu_feed_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset + 212, 0, 108, menuHeight);
    btn.tag = 102;
    
    [btn setBackgroundImage:idle forState:UIControlStateNormal];
    [btn setBackgroundImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onFollowedClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    [menuArray addObject:menuBar];
    [menuBar release];
    
    // bar2
    menuBar = [[UIView alloc] initWithFrame:CGRectMake(-offset, menuHeight, 320, menuHeight)];
    menuBar.backgroundColor = [UIColor whiteColor];
    
    CGSize shadowOffset = CGSizeZero;
    shadowOffset.height = 8.0;
    menuBar.layer.shadowOffset = shadowOffset;
    menuBar.layer.shadowColor = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
    menuBar.layer.shadowOpacity = 0.4;
    
    // explorer
    idle = [UIImage imageNamed:@"menu_explore.png"];
    click = [UIImage imageNamed:@"menu_explore_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset, 0, 106, menuHeight);
    btn.tag = 103;
    
    [btn setImage:idle forState:UIControlStateNormal];
    [btn setImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onExplorerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    // camera
    idle = [UIImage imageNamed:@"menu_camera.png"];
    click = [UIImage imageNamed:@"menu_camera_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset + 106, 0, 106, menuHeight);
    btn.tag = 104;
    
    [btn setImage:idle forState:UIControlStateNormal];
    [btn setImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    // notice
    idle = [UIImage imageNamed:@"menu_alert.png"];
    click = [UIImage imageNamed:@"menu_alert_press.png"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offset + 212, 0, 108, menuHeight);
    btn.tag = 105;
    [btn setImage:idle forState:UIControlStateNormal];
    [btn setImage:click forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onNoticeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menuBar addSubview:btn];
    
    [menuArray addObject:menuBar];
    [menuBar release];
    
  
    [self prepareRobbon];
    //init index
    index = 3;
    [self restIcon:index];
}
- (void)prepareRobbon
{
    // add ribbon
    ribbon = [[UIView alloc] initWithFrame:CGRectMake(260, 0 -5, 55, 65)];
    UIImageView *ribbonImg = [[[UIImageView alloc] initWithFrame:self.ribbon.bounds] autorelease];
    [ribbonImg setImage:[UIImage imageNamed:@"bookmark.png"]];
    ribbon.backgroundColor = [UIColor clearColor];
    [ribbon addSubview:ribbonImg];

}
- (void)viewDidUnload
{
    self.rootView = nil;
    self.coverView = nil;
    self.menuArray = nil;
    self.naviView = nil;
    self.ribbonFake = nil;
    self.ribbon = nil;
}

- (void)resetMenu
{
    isMoving = FALSE;
    isMenuShowing = FALSE;
}


#pragma mark -
#pragma Login
- (void)SCPLogin:(SCPLoginViewController *)LoginController cancelLogin:(UIButton *)button
{
    [navController dismissModalViewControllerAnimated:YES];
}

- (void)SCPLogin:(SCPLoginViewController *)LoginController doLogin:(UIButton *)button
{
    NSLog(@"SCPLogin");
    [navController dismissModalViewControllerAnimated:NO];
    if (self.homelogin == LoginController) {
        [self onAccountClicked:nil];
    }else if(self.uLoadLogin == LoginController){
        [self onBatchClicked:nil];
    }else{
        [self onNoticeClicked:nil];

    }
}

#pragma mark -
#pragma mark navigation aniamtion
- (void)popNavigationList
{
    isMenudone  = YES;
    self.navController.delegate = self;
    [self popNavigationInDuration:0.03];
}

- (void)popNavigationInDuration:(CGFloat)duration
{
    if (self.navController.childViewControllers.count == 1) {
        SCPMainTabController *tabCtrl = [navController.childViewControllers objectAtIndex:0];
        [self hideMenuWithRibbon:NO];
        [tabCtrl switchToindex:index == 3 ? 0 : 1];
        [self restIcon:index];
        return;
    }
    [self.navController popToRootViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated && isMenudone) {
        SCPMainTabController *tabCtrl = [navController.childViewControllers objectAtIndex:0];
        [self hideMenuWithRibbon:NO];
        isMenudone = NO;
        if (tabCtrl.selectedIndex == 0 && index == 3) {
            return;
        }
        if (tabCtrl.selectedIndex == 1 && index == 2) {
            return;
        }
        [tabCtrl switchToindex:index == 3 ? 0 : 1];
        [self restIcon:index];

    }
}

#pragma mark -
#pragma mark Page UP

- (void)onBatchClicked:(id)sender
{
    [self hideMenuWithRibbon:NO];
    if (![SCPLoginPridictive isLogin]) {
        self.uLoadLogin = [[[SCPLoginViewController alloc] init] autorelease];
        self.uLoadLogin.delegate = self;
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:self.uLoadLogin] autorelease];
        [navController presentModalViewController:nav animated:YES];
        return;
    }
    AlbumControllerManager * manager = [[AlbumControllerManager alloc] initWithpresentController:self.navController];
	[self.navController presentModalViewController:manager animated:YES];
    [manager release];
    
}

- (void)onAccountClicked:(id)sender
{
    
    [self hideMenuWithRibbon:NO];
    if (![SCPLoginPridictive isLogin]) {
        self.homelogin = [[[SCPLoginViewController alloc] init] autorelease];
        self.homelogin.delegate = self;
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:self.homelogin] autorelease];
        [navController presentModalViewController:nav animated:YES];
        return;
    }
    if ([[self.navController.viewControllers lastObject] isKindOfClass:[SCPMyHomeViewController class]]) {
        return;
    }
    SCPMyHomeViewController * myhome = [[[SCPMyHomeViewController alloc]initWithNibName:nil bundle:nil useID:[SCPLoginPridictive currentUserId]]autorelease];
    [self.navController pushViewController:myhome animated:YES];
    [self restIcon:1];

}

- (void)onFollowedClicked:(id)sender
{
    SCPMainTabController *tabCtrl = [navController.childViewControllers objectAtIndex:0];
    if (tabCtrl.selectedIndex == 1 && self.navController.viewControllers.count == 1) {
        [self hideMenuWithRibbon:NO];
        return;
    }
    index = 2;
    [self popNavigationList];

}
#pragma mark Page Down
- (void)onExplorerClicked:(id)sender
{
    SCPMainTabController *tabCtrl = [navController.childViewControllers objectAtIndex:0];
    if (tabCtrl.selectedIndex == 0 && self.navController.viewControllers.count == 1) {
        [self hideMenuWithRibbon:NO];
        return;
    }
    index = 3;
    [self popNavigationList];
}

- (void)onCameraClicked:(id)sender
{
    [self hideMenuWithRibbon:NO];
    CameraViewController * phc = [[[CameraViewController alloc] init]autorelease];
    [navController performSelector:@selector(pushViewController:animated:) withObject:phc afterDelay:0];
    
}

- (void)onNoticeClicked:(id)sender
{
    //提醒....
    [self hideMenuWithRibbon:NO];
    if (![SCPLoginPridictive isLogin]) {
        SCPLoginViewController * login = [[[SCPLoginViewController alloc] init] autorelease];
        login.delegate = self;
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:login] autorelease];
        [navController presentModalViewController:nav animated:YES];
        return;
    }
    if ([self.navController.visibleViewController isKindOfClass:[NoticeViewController class]]) {
        return;
    }
     NoticeViewController * nvc = [[[NoticeViewController alloc] init] autorelease];
    [self.navController pushViewController:nvc animated:YES];
}


#pragma mark -
#pragma mark icon
- (void)restIcon:(NSInteger)sender
{
    UIButton *mybutton = nil;
    UIView *view = [menuArray objectAtIndex:0];
    for (UIButton * button in view.subviews) {
        [button setImage:[UIImage imageNamed:menuNormal[button.tag - 100]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:menuPress[button.tag - 100]] forState:UIControlStateHighlighted];
        if (button.tag == sender + 100) {
            mybutton = button;
        }
    }
    UIView * view1 = [menuArray objectAtIndex:1];
    for (UIButton *button in view1.subviews) {
        [button setImage:[UIImage imageNamed:menuNormal[button.tag - 100]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:menuPress[button.tag - 100]] forState:UIControlStateHighlighted];
        if (button.tag == sender + 100) {
            mybutton = button;
        }
    }
    [mybutton setImage:[UIImage imageNamed:menuNormal[mybutton.tag - 100]] forState:UIControlStateHighlighted];
    [mybutton setImage:[UIImage imageNamed:menuPress[mybutton.tag - 100]] forState:UIControlStateNormal];
}


#pragma mark -
#pragma ribbion target
- (void)showMenuWithRibbon
{
    if (isMenuShowing || isMoving) return;
    NSLog(@"showMenu");
    isMoving = TRUE;
    isMenuShowing = YES;
    [[[[UIApplication sharedApplication] delegate] window] setUserInteractionEnabled:NO];
    [rootView setHidden:NO];
    for (int i = 0; i < menuArray.count; i++) {
        UIView *view = [menuArray objectAtIndex:i];
        view.frame = CGRectMake(-offset, menuHeight * i, 380, menuHeight);
        CALayer * layer = view.layer;
        
        //rotation
        float fx = -1.0;
        if (i % 2) {
            fx = 1.0;
        }
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(90), fx, 0,0)];
        
        transformAnimation.duration = animationDuration;
        transformAnimation.timeOffset = animationDuration;
        transformAnimation.autoreverses = YES;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        //move
        CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        translateAnimation.fromValue = [NSValue valueWithCGPoint:layer.position];
        CGPoint toPoint = layer.position;
        if (i % 2) {
            toPoint.y -= menuHeight;
        }
        toPoint.y -= i * menuHeight;
        translateAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
        translateAnimation.duration = animationDuration;
        translateAnimation.timeOffset = animationDuration;
        translateAnimation.autoreverses = YES;
        CAMediaTimingFunction *timingFunc = [self getMoveTimingFunc];
        translateAnimation.timingFunction = timingFunc;
        translateAnimation.repeatCount = 0.5;
        
        //color
        CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        color.duration = animationDuration;
        if (i % 2) {
            color.fromValue = (id)[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
        } else {
            color.fromValue = (id)[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
        }
        color.toValue = (id)[UIColor whiteColor].CGColor;
        
        //group
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = animationDuration;
        group.delegate = self;
        group.animations = [NSArray arrayWithObjects:transformAnimation,translateAnimation,color, nil];
        layer.edgeAntialiasingMask = kCALayerLeftEdge|kCALayerRightEdge;
//        layer.shouldRasterize = YES;
        [layer addAnimation:group forKey:nil];
        
        //color
    }
    
    //move ribbon
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint toPoint = ribbon.layer.position;
//    toPoint.y += menuHeight * 2;
    toPoint = CGPointMake(toPoint.x, 127.5);
    
    translateAnimation.fromValue = [NSValue valueWithCGPoint:toPoint];
    translateAnimation.toValue = [NSValue valueWithCGPoint:ribbon.layer.position];
    translateAnimation.duration = animationDuration;
    translateAnimation.timeOffset = animationDuration;
    translateAnimation.autoreverses = YES;
    CAMediaTimingFunction *timingFunc = [self getMoveTimingFunc];
    translateAnimation.timingFunction = timingFunc;
    [array addObject:translateAnimation];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = array;
    group.delegate = self;
    [group setDuration:animationDuration];
    [ribbon.layer addAnimation:group forKey:nil];
    ribbon.layer.position = toPoint;
    
}
- (CAMediaTimingFunction *)myfunctionTime
{
    return [CAMediaTimingFunction functionWithControlPoints:0.20 :0.00 :0.6 :0.67];
}
- (void)hideMenuWithRibbon:(BOOL)hideRibbon
{
    
    NSLog(@"isMenudone :%d,isMoving :%d ",isMenudone, isMoving);
    if (!isMenuShowing || isMoving)  return;
    NSLog(@"hideMenu");
    isMoving = TRUE;
    [[[[UIApplication sharedApplication] delegate] window] setUserInteractionEnabled:NO];
    isMenuShowing = NO;
    for (int i = 0; i < menuArray.count; i++) {
        UIView *view = [menuArray objectAtIndex:i];
        CALayer * layer = view.layer;
        //rotation
        float fx = -1.0;
        if (i % 2) {
            fx = 1.0;
        }
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(90), fx, 0,0)];
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15 :0.25 :0.9 :0.9];
        transformAnimation.duration = animationDuration;
        //move
        CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        translateAnimation.fromValue = [NSValue valueWithCGPoint:layer.position];
        CGPoint toPoint = layer.position;
        NSLog(@"hide menum %@",NSStringFromCGPoint(layer.position));
//        if(i % 2){
//            toPoint.y -= menuHeight;
//        }
//        toPoint.y -= i * menuHeight;
        
        toPoint.y = 0;
        translateAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
        translateAnimation.duration = animationDuration;
        if (i == 0) {
            translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        }else{
            translateAnimation.timingFunction = [self myfunctionTime];
        }
      
        //color
        CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        color.duration = animationDuration;
        color.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        if (i % 2) {
            color.toValue = (id) [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
        }else {
            color.toValue = (id) [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
        }
        color.fromValue = (id) [UIColor whiteColor].CGColor;
        //group
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithObjects:transformAnimation,translateAnimation,color, nil];
        group.duration = animationDuration;
        [layer addAnimation:group forKey:nil];
        layer.position = CGPointMake(160, -menuHeight);
    }
    
    //move ribbon
    NSMutableArray *animArray = [[[NSMutableArray alloc] init] autorelease];
    
    CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint toPoint = ribbon.layer.position;

    toPoint.y -= menuHeight * 2;
    if (hideRibbon) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = animationDuration;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        
        [animArray addObject:opacityAnimation];
    }
    translateAnimation.fromValue = [NSValue valueWithCGPoint:ribbon.layer.position];
    translateAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    translateAnimation.duration = animationDuration;
    CAMediaTimingFunction *timingFunc = [self getMoveTimingFunc];
    translateAnimation.timingFunction = timingFunc;

    [animArray addObject:translateAnimation];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = animArray;
    group.delegate = self;
    [group setDuration:animationDuration];
    [ribbon.layer addAnimation:group forKey:nil];
    if (hideRibbon) {
        toPoint.y -= menuHeight * 2;
    }
    ribbon.layer.position = toPoint;
}

- (void)hideRibbonWithAnimation:(BOOL)animation
{
    if (animation) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = animationDuration;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint toPoint = ribbon.layer.position;
        toPoint.y = - 27.5;
        translateAnimation.fromValue = [NSValue valueWithCGPoint:ribbon.layer.position];
        translateAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
        translateAnimation.duration = animationDuration;
        translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        CAAnimationGroup *group= [CAAnimationGroup animation];
        group.animations = [[[NSArray alloc] initWithObjects:opacityAnimation, translateAnimation, nil] autorelease];
        [ribbon.layer addAnimation:group forKey:nil];

    }
    ribbon.layer.position = CGPointMake(ribbon.layer.position.x, -27.5);
    ribbon.layer.opacity = 0.0;
    
}
- (void)showRibbonWithAnimation:(BOOL)animation

{
    
    CGPoint toPoint = CGPointMake(ribbon.layer.position.x, 27.5);
    if (animation) {
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = animationDuration;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation * translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        translateAnimation.fromValue = [NSValue valueWithCGPoint:ribbon.layer.position];
        translateAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
        translateAnimation.duration = animationDuration;
        
        translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup *group= [CAAnimationGroup animation];
        group.animations = [[[NSArray alloc] initWithObjects:opacityAnimation, translateAnimation, nil] autorelease];
        [group setDuration:animationDuration];
        [ribbon.layer addAnimation:group forKey:nil];
    }
    ribbon.layer.position = toPoint;
    ribbon.layer.opacity = 1.0;
    
}

- (CAMediaTimingFunction *)getMoveTimingFunc
{
    return [CAMediaTimingFunction functionWithControlPoints:0.35 :0.0 :0.6 :0.67];
}

#pragma mark -
#pragma animationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[[[UIApplication sharedApplication] delegate] window] setUserInteractionEnabled:YES];
    if (isMenuShowing) {
        [self menuDidShow];
    } else {
        [self menuDidHide];
    }
}

- (void)menuDidHide
{
    NSLog(@"didHide");
    isMoving = FALSE;
    ribbonFake.frame = ribbon.frame;
    [rootView setHidden:YES];
    if ([self.menuDelegate respondsToSelector:@selector(menuDidHide)]) {
        [self.menuDelegate menuDidHide];
    }
}

- (void)menuDidShow
{
    NSLog(@"didSHow");
    isMoving = FALSE;
    ribbonFake.frame = ribbon.frame;
    if ([self.menuDelegate respondsToSelector:@selector(menuDidShow)]) {
        [self.menuDelegate menuDidShow];
    }
}

@end
