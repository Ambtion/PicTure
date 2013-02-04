//
//  FeedListManager.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshController.h"

#import "MainFeedBanner.h"
#import "FeedCell.h"
#import "LoginTipView.h"
#import "SCPLoginViewController.h"
#import "SCPRequestManager.h"


@class SCPFeedController;
@interface FeedManager : NSObject <UITableViewDataSource, PullingRefreshDelegate,BannerDataSoure,FeedCellDelegate,SCPLoginViewDelegate,SCPRequestManagerDelegate>

{
    
    SCPRequestManager * _requestManager;
    NSMutableArray * _dataArray;
    LoginTipView * _LoginTip;
    BOOL _willRefresh;
    BOOL _isLoading;
    BOOL _isInit;
    NSInteger _allFollowed;
    BOOL hasNextPage;
    BOOL curpage;
}

@property(assign,nonatomic)SCPFeedController*  controller;
@property(nonatomic,retain)NSMutableArray * headViewdata;
@property(nonatomic,retain)NSArray * dataArray;
@property(nonatomic,assign)BOOL isLoading;

- (id)initWithController:(SCPFeedController *)controller;
- (void)refreshData:(id)sender;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)showViewForNoLogin;
- (void)dismissLogin;
@end
