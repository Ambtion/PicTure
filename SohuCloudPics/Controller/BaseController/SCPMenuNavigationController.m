//
//  SCPMenuNavigationController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//menuMangeger视图的显示载体

#import "SCPMenuNavigationController.h"

#import <QuartzCore/QuartzCore.h>
#import "SCPMainTabController.h"

static CATransform3D CATransform3DMakePerspective(CGFloat z)
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0 / z;
    return t;
}

@implementation SCPMenuNavigationController

@synthesize disableMenu = _disableMenu;
@synthesize disableRibbon = _disableRibbon;
@synthesize menuManager = _menuManager;
@synthesize menuView = _menuView;
@synthesize ribbonView = _ribbonView;
//@synthesize ribbonViewFake;
@synthesize myNavigationBar;

@synthesize needHide;
@synthesize needShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _disableMenu = FALSE;
        _menuManager = [[SCPMenuManager alloc] init];
        _menuManager.navController = self;
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
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"ground.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
}

#pragma mark -
#pragma initview

- (void)initMenu
{
    // add 3DLayer
    [_menuManager prepareView];
    [self configMenuManager];
    [self addGestureOnRibbon];
}
- (void)configMenuManager
{
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _menuView.layer.sublayerTransform = CATransform3DMakePerspective(1000);
    _menuView.backgroundColor = [UIColor clearColor];
    _menuManager.naviView = self.view;
    [_menuView setHidden:YES];
    [self.view addSubview:_menuView];
    // add menu
    NSMutableArray *views = _menuManager.menuArray;
    int i = 0;
    for (UIView *menu in views) {
        if (i % 2) {
            menu.layer.anchorPoint = CGPointMake(0.5, 1.0);
            menu.layer.position = CGPointMake(160, (i + 1) * _menuManager.menuHeight);
        } else {
            menu.layer.position = CGPointMake(160, i * _menuManager.menuHeight);
            menu.layer.anchorPoint = CGPointMake(0.5, 0.0);
        }
        [_menuView addSubview:menu];
        i++;
    }
    _menuManager.rootView = _menuView;
    // add ribbon
    self.ribbonView = _menuManager.ribbon;
    [self.view addSubview:_ribbonView];
}
- (void)addGestureOnRibbon
{
    // add gsetrure up ,down ,tap
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    [down setDirection:UISwipeGestureRecognizerDirectionDown];
    [_ribbonView addGestureRecognizer:down];
    [down release];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
    [up setDirection:UISwipeGestureRecognizerDirectionUp];
    [_ribbonView addGestureRecognizer:up];
    [up release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchMenu:)];
    [_ribbonView addGestureRecognizer:tap];
    [tap release];
}

#pragma mark SwitchMenu
- (void)switchMenu:(UIGestureRecognizer *)recognizer
{
    if (_menuManager.isMenuShowing) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}
- (void)showMenu
{
    if (_disableMenu) return;
    [_menuManager showMenuWithRibbon];
}

- (void)hideMenu
{
    if (_disableMenu) return;
    [_menuManager hideMenuWithRibbon:NO];
}

#pragma mark  - disableMenu

- (void)setDisableMenus:(BOOL)disable
{
    
    if (_ribbonView)  [_ribbonView setHidden:disable];
    _disableMenu = disable;
}

- (void)setDisableRibbon:(BOOL)disable
{
    [self.ribbonView setHidden:disable];
    _disableRibbon = disable;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (_disableMenu)    return;
    if (_disableRibbon)  return;
    if (!animated) {
        [super setNavigationBarHidden:hidden animated:animated];
        return;
    }
    if (_menuManager.isMoving)  return;
    
    if (hidden) {
        if (_menuManager.isMenuShowing) {
            // 隐藏Menu和ribbon
            [_menuManager hideMenuWithRibbon:YES];
        } else {
            // 只隐藏ribbon
            [_menuManager hideRibbonWithAnimation:YES];
        }
    } else {
        if (!_menuManager.isMenuShowing) {
            [_menuManager showRibbonWithAnimation:YES];
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
    [self resetMenu];
    [super pushViewController:viewController animated:animated];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * vc  = [super popViewControllerAnimated:animated];
    if (self.childViewControllers.count == 1) [self reseticon];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
    return vc;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray * vcArray  = [super popToRootViewControllerAnimated:animated];
    if (self.childViewControllers.count == 1) [self reseticon];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
    return vcArray;
}

- (void)reseticon
{
    SCPMainTabController * maintab = [self.childViewControllers objectAtIndex:0];
    switch (maintab.selectedIndex) {
        case 0:
            [self.menuManager restIcon:3];
            break;
        case 1:
            [self.menuManager restIcon:2];
            break;
        default:
            break;
    }
} 
- (void)resetMenu
{
    if ([self.menuManager isMenuShowing]) [self hideMenu];
    [self.view insertSubview:self.navigationBar belowSubview:self.menuView];
    [self.menuManager resetMenu];
}

@end
