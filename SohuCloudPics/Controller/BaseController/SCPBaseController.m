//
//  SCPBaseController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


//Describtion add up ,down gesture for hid navigationbar

#import "SCPBaseController.h"
#import "SCPMenuNavigationController.h"
#import "CameraViewController.h" //show camera

@implementation SCPBaseController
@synthesize naviRecognizerDown = _naviRecognizerDown;
@synthesize naviRecognizerUp = _naviRecognizerUp;
@synthesize slideRecognizerR2L = _slideRecognizerR2L;

- (void)dealloc
{
    self.naviRecognizerDown = nil;
    self.naviRecognizerUp = nil;
    self.slideRecognizerR2L = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _naviRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
        _naviRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
        _naviRecognizerDown.delegate = self;
        _naviRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavigationBar)];
        _naviRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
        _naviRecognizerUp.delegate = self;
        _slideRecognizerR2L = [[SCPHorizontalGestureRecognizer alloc] initWithTarget:self action:@selector(showCamera:)];
        _slideRecognizerR2L.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:_naviRecognizerDown];
    [self.view addGestureRecognizer:_naviRecognizerUp];
    [self.view addGestureRecognizer:_slideRecognizerR2L];    
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

- (NSString *)timeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM-dd H:mm"];
    return   [dateFormatter stringFromDate:date];
}

- (void)showCamera:(id)gesture
{
    CameraViewController *phc = [[CameraViewController alloc] init];
    [self hideNavigationBar];
    [self.navigationController pushViewController:phc animated:YES];
    [phc release];
}

#pragma mark - navigationBar action

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

#pragma mark - UIGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
