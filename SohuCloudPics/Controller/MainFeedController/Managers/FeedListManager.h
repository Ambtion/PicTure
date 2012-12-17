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

@class SCPMainFeedController;
@interface FeedListManager : NSObject <UITableViewDataSource, PullingRefreshDelegate,BannerDataSoure,FeedCellDelegate,SCPLoginViewDelegate,SCPRequestManagerDelegate>
{
    SCPRequestManager * _requestManager;
    NSMutableArray * _dataArray;
    LoginTipView * _LoginTip;
    BOOL _willRefresh;
    BOOL _isLoading;
    BOOL _isInit;
    NSInteger allFollowed;
}

@property(assign,nonatomic)SCPMainFeedController*  controller;
@property(nonatomic,retain)NSMutableArray * headViewdata;

- (id)initWithController:(SCPMainFeedController *)controller;
- (void)refreshData:(id)sender;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)showViewForNoLogin;
- (void)dismissLogin;
@end
