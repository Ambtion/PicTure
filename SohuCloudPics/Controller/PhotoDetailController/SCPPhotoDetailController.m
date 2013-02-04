//
//  SCPPhotoDetailViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
// 照片详情页面. 图片 + 描述

#import "SCPMenuNavigationController.h"
#import "SCPPhotoDetailController.h"

@implementation SCPPhotoDetailController

@synthesize manager = _manager;
@synthesize pullingController = _pullingController;

- (void)dealloc
{
    self.manager.controller = nil;
    [_manager release];
    [_pullingController release];
    [super dealloc];
}

- (id)initWithUserId:(NSString*) userId photoId:(NSString*)photoId
{
    self = [super init];
    if (self) {
        _manager = [[PhotoDetailManager alloc] initWithController:self UserId:userId PhotoId:photoId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_photos.png"] frame:self.view.bounds] autorelease];
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.pullingController.footView setHidden:YES];
    [self.view addSubview:self.pullingController.view];
}

#pragma mark customer Navigationiteam
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 35, 35);
    
    UIBarButtonItem* left = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = left;
    [self.manager dataSourcewithRefresh:YES];
}

- (void)navigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
