//
//  SCPMenuNavigationController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPMenuNavigationController.h"

#import <QuartzCore/QuartzCore.h>


static CATransform3D CATransform3DMakePerspective(CGFloat z)
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0 / z;
    return t;
}

@implementation SCPMenuNavigationController

@synthesize disableMenu;
@synthesize disableRibbon;
@synthesize menuManager;
@synthesize menuView;
@synthesize ribbonView;
//@synthesize ribbonViewFake;
@synthesize myNavigationBar;

@synthesize needHide;
@synthesize needShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        disableMenu = FALSE;
        menuManager = [[SCPMenuManager alloc] init];
        menuManager.navController = self;
    }
    return self;
}

- (void)dealloc
{
    self.myNavigationBar = nil;
    self.ribbonView = nil;
    self.menuView = nil;
    self.menuManager = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customeNavigationBar];
    [self initMenu];
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    
}

- (void)customeNavigationBar
{
    //    self.view.backgroundColor = [UIColor clearColor];
    //    [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setTranslucent:YES];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    [menuManager viewDidUnload];
    self.ribbonView = nil;
    self.menuView = nil;
    self.myNavigationBar = nil;
    
}

#pragma mark -
#pragma setup user btn


#pragma mark -
#pragma initview
- (void)initMenu
{
    // add 3DLayer
    [menuManager prepareView];
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    menuView.layer.sublayerTransform = CATransform3DMakePerspective(1000);
    menuView.backgroundColor = [UIColor redColor];
    menuManager.naviView = self.view;
    
    [menuView setHidden:YES];
    [self.view addSubview:menuView];
    
    // add menu
    NSMutableArray *views = menuManager.menuArray;
    int i = 0;
    for (UIView *menu in views) {
        if (i % 2) {
            menu.layer.anchorPoint = CGPointMake(0.5, 1.0);
            menu.layer.position = CGPointMake(160, (i + 1) * menuManager.menuHeight);
        } else {
            menu.layer.position = CGPointMake(160, i * menuManager.menuHeight);
            menu.layer.anchorPoint = CGPointMake(0.5, 0.0);
        }
        [menuView addSubview:menu];
        i++;
    }
    
    menuManager.rootView = menuView;
    
    // add ribbon
    self.ribbonView = menuManager.ribbon;
    [self.view addSubview:ribbonView];
    
    [self addGesTure];
    
}

- (void)addGesTure
{
    // add gsetrure up ,down ,tap
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    [down setDirection:UISwipeGestureRecognizerDirectionDown];
    [ribbonView addGestureRecognizer:down];
    [down release];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
    [up setDirection:UISwipeGestureRecognizerDirectionUp];
    [ribbonView addGestureRecognizer:up];
    [up release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchMenu:)];
    [ribbonView addGestureRecognizer:tap];
    [tap release];
}

#pragma mark SwitchMenu
- (void)switchMenu:(UIGestureRecognizer *)recognizer
{
    if (menuManager.isMenuShowing) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}
- (void)showMenu
{
    if (disableMenu) return;
    [menuManager showMenuWithRibbon];
}

- (void)hideMenu
{
    if (disableMenu) return;
    [menuManager hideMenuWithRibbon:NO];
}

//- (void)resetMenu
//{
//    disableRibbon = NO;
//    [self setNavigationBarHidden:NO];
//    [self setDisableMenus:NO];
//}

- (void)setDisableMenus:(BOOL)disable
{
    
    if (ribbonView)  [ribbonView setHidden:disable];
    disableMenu = disable;
}

- (void)setDisableRibbon:(BOOL)disable
{
    [self.ribbonView setHidden:disable];
    disableRibbon = disable;
}


- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (disableMenu)    return;
    if (disableRibbon)  return;
    
    if (!animated) {
        [super setNavigationBarHidden:hidden animated:animated];
        return;
    }
    if (menuManager.isMoving)  return;
    
    if (hidden) {
        if (menuManager.isMenuShowing) {
            // 隐藏Menu和ribbon
            [menuManager hideMenuWithRibbon:YES];
        } else {
            // 只隐藏ribbon
            [menuManager hideRibbonWithAnimation:YES];
        }
    } else {
        NSLog(@"[self.ribbonViewFake setHidden:NO];");
        if (!menuManager.isMenuShowing) {
            [menuManager showRibbonWithAnimation:YES];
            [self performSelector:@selector(restMenuViewLayer:) withObject:nil afterDelay:0.3];
        }
    }
    [super setNavigationBarHidden:hidden animated:animated];
}
- (void)restMenuViewLayer:(id)sendre
{
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.menuManager hideMenuWithRibbon:NO];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * vc  = [super popViewControllerAnimated:animated];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
    return vc;
}
- (void)resetMenu
{
    if ([self.menuManager isMenuShowing]) [self hideMenu];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
    [self.menuManager resetMenu];
}
@end
