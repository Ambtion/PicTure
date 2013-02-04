//
//  SCPSecondLayerController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// 定义后退手势行为

#import "SCPSecondController.h"
#import "SCPMenuNavigationController.h"
#import "SCPHorizontalGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

@implementation SCPSecondController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SCPHorizontalGestureRecognizer *back = [[SCPHorizontalGestureRecognizer alloc] initWithTarget:self action:@selector(onBackSwipe:)];
    back.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:back];
    [back release];
    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)showCamera:(id)gesture
{
    //重载函数,二级页面失去右滑手势
}

- (void)onBackSwipe:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
