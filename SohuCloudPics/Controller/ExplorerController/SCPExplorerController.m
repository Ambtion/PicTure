//
//  ExploreViewController.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPExplorerController.h"
#import "SCPMainFeedController.h"
#import "SCPGuideView.h"

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
    if (_item == nil) {
        _item = [[SCPBaseNavigationItem alloc] initWithNavigationController:self.navigationController];
        [_item addRefreshtarget:self action:@selector(refreshButton:)];
    }
    if (!_item.superview)
        [self.navigationController.navigationBar addSubview:_item];
    [super viewDidAppear:animated];
    [self showGuideView];
}

- (void)showGuideView
{
    NSNumber * num = [[NSUserDefaults standardUserDefaults] objectForKey:@"GuideViewShowed"];
    if (!num || ![num boolValue]) {
        SCPGuideView * view = [[[SCPGuideView alloc] initWithFrame:self.view.bounds] autorelease];
        if ([[UIScreen mainScreen] bounds].size.height > 480) {
            view.image = [UIImage imageNamed:@"exporeGuideIos6_2.png"];
        }else{
            view.image = [UIImage imageNamed:@"exporeGuide.png"];
        }
        [view show];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"GuideViewShowed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
