//
//  PhotoTableManager.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshController.h"
#import "PlazeViewCell.h"

#import "SCPRequestManager.h"

@class SCPPlazeController;

@interface PlazeManager : NSObject <UITableViewDataSource, PullingRefreshDelegate, BannerDataSoure,PlazeViewCellDelegate>
{
    SCPRequestManager * _requestManager;
    NSMutableArray * _strategyArray;
    BOOL _isLoading;
    BOOL _isRefreshing;
    BOOL _isiniting;
    NSUInteger _startoffsetForRequset;
}

@property (assign) BOOL isLoading;
@property (assign) SCPPlazeController *controller;

- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)refreshData:(id)sender;
@end
