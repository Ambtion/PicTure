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
@synthesize item = _item;
- (void)dealloc
{
    [_item release];
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
    _pullingController = [[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_explore.png"] frame:self.view.bounds];
    self.pullingController.view.frame = self.view.bounds;
    self.manager.controller = self;
    
    //customer for  scrollview
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.view addSubview:self.pullingController.view];
    
}
- (void)refreshButton:(UIButton *)button
{
    if (self.manager.isLoading) return;
    if ([self.pullingController.tableView numberOfSections]){
        [self.pullingController.tableView setContentOffset:CGPointZero];
    }
    [self.manager refreshData:nil];
}

#pragma mark -
#pragma mark NavigationItem customer
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_item == nil) {
        _item = [[SCPBaseNavigationItem alloc] initWithNavigationController:self.navigationController];
        [_item addRefreshtarget:self action:@selector(refreshButton:)];
    }
    if (!_item.superview)
        [self.navigationController.navigationBar addSubview:_item];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (_item.superview) {
        [_item removeFromSuperview];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_item.superview) {
        [_item removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning
{
    //for memory controller
    [super didReceiveMemoryWarning];
}
@end
