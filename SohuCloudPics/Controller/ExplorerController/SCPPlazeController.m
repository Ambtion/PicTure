//
//  PlazeViewController.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPPlazeController.h"
#import "SCPFeedController.h"

@implementation SCPPlazeController

@synthesize pullingController = _pullingController;
@synthesize manager = _manager;
@synthesize refreshItem = _refreshItem;

- (void)dealloc
{
    [_refreshItem release];
    [_pullingController release];
    [_manager release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
    [self.pullingController realLoadingMore:nil];
}

- (void)addTableView
{
    _manager = [[PlazeManager alloc] init];
    self.manager.controller = self;

    _pullingController = [[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_explore.png"] frame:self.view.bounds];
    self.pullingController.view.frame = self.view.bounds;
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.view addSubview:self.pullingController.view];
}

- (void)refreshButton:(UIButton *)button
{
    if (self.manager.isLoading) return;
    if ([self.pullingController.tableView numberOfSections])
        [self.pullingController.tableView setContentOffset:CGPointZero];
    [self.manager refreshData:nil];
}

#pragma mark  - RefreshItem customer
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_refreshItem == nil) {
        _refreshItem = [[SCPBaseNavigationItemView alloc] initWithNavigationController:self.navigationController];
        [_refreshItem refreshButtonAddtarget:self action:@selector(refreshButton:)];
    }
    if (!_refreshItem.superview)
        [self.navigationController.navigationBar addSubview:_refreshItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_refreshItem.superview) {
        [_refreshItem removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_refreshItem.superview) {
        [_refreshItem removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    //for memory controller
    [super didReceiveMemoryWarning];
}
@end
