//
//  SCPSecondLayerController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPSecondLayerController.h"

#import "SCPMenuNavigationController.h"
#import "SCPHorizontalGestureRecognizer.h"

#import <QuartzCore/QuartzCore.h>


@implementation SCPSecondLayerController

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCPHorizontalGestureRecognizer *back = [[SCPHorizontalGestureRecognizer alloc] initWithTarget:self action:@selector(onBackSwipe:)];
    back.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:back];
    [back release];
    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)showCamera:(id)gesture
{
    //重载函数,使2级页面失去划出相机的功能;
//    NSLog(@"重载函数,是2级页面失去划出相机的功能");
}
- (void)onBackSwipe:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
