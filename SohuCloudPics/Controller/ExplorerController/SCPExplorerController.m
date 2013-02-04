//
//  ExploreViewController.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPExplorerController.h"
#import "SCPMainFeedController.h"

@implementation SCPExplorerController

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
//    [self showGuideView];
}

- (void)addTableView
{
    self.manager = [[[ExploreTableManager alloc] init] autorelease];
    self.pullingController = [[[PullingRefreshController alloc] initWithImageName:[UIImage imageNamed:@"title_explore.png"] frame:self.view.bounds] autorelease];
    self.pullingController.view.frame = self.view.bounds;
    self.manager.controller = self;
    
    //customer for  scrollview
    self.pullingController.delegate = self.manager;
    self.pullingController.tableView.dataSource = self.manager;
    self.pullingController.headView.datasouce = self.manager;
    [self.view addSubview:self.pullingController.view];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pullingController = nil;
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
#pragma mark customerNavigationIteam

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"%d MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",[[UIApplication sharedApplication] isIdleTimerDisabled]);
    if (_item == nil) {
        _item = [[SCPBaseNavigationItem alloc] initWithNavigationController:self.navigationController];
        [_item addRefreshtarget:self action:@selector(refreshButton:)];
    }
    if (!_item.superview)
        [self.navigationController.navigationBar addSubview:_item];
    [super viewDidAppear:animated];
    
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
@end
