//
//  SCPBaseController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


//Describtion add up ,down gesture for hid navigationbar

#import "SCPBaseController.h"

#import "SCPMenuNavigationController.h"
#import "SCPHorizontalGestureRecognizer.h"
#import "CameraViewController.h"


#define SYSTERVISION  [[UIDevice currentDevice] systemVersion]

@implementation SCPBaseController

@synthesize naviRecognizerDown;
@synthesize naviRecognizerUp;
@synthesize slideRecognizerR2L;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        naviRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
        naviRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
        naviRecognizerDown.delegate = self;
        naviRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavigationBar)];
        naviRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
        naviRecognizerUp.delegate = self;
        slideRecognizerR2L = [[SCPHorizontalGestureRecognizer alloc] initWithTarget:self action:@selector(showCamera:)];
        slideRecognizerR2L.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return self;
}

- (void)dealloc
{
    self.naviRecognizerDown = nil;
    self.naviRecognizerUp = nil;
    self.slideRecognizerR2L = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:naviRecognizerDown];
    [self.view addGestureRecognizer:naviRecognizerUp];
    [self.view addGestureRecognizer:slideRecognizerR2L];
    needHideNavigationBar = FALSE;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBar];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showNavigationBar];
}
- (void)onBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)getTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM-dd H:mm"];
    return   [dateFormatter stringFromDate:date];
}
#pragma mark -
#pragma mark delegate
- (void)showCamera:(id)gesture
{
    CameraViewController *phc = [[CameraViewController alloc] init];
    [self hideNavigationBar];
    [self.navigationController pushViewController:phc animated:YES];
    [phc release];
}
#pragma mark -
#pragma switchNavigationBar
- (void)switchNavigationBar:(float)yOffset scrollView:(UIScrollView *)scrollView
{
    if (yOffset <= 0) {
        [self showNavigationBar];
    } else {
        if (needHideNavigationBar) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        needHideNavigationBar = FALSE;
    }
    lastOffset = yOffset;
}

- (void)showNavigationBar
{
    if (self.navigationController.navigationBarHidden && [self.navigationController isKindOfClass:[SCPMenuNavigationController class]])
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController isKindOfClass:[SCPMenuNavigationController class]])
        [((SCPMenuNavigationController *)self.navigationController) resetMenu];
}
- (void)hideNavigationBar {
    if (!self.navigationController.navigationBarHidden && [self.navigationController isKindOfClass:[SCPMenuNavigationController class]]) 
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -
#pragma UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
