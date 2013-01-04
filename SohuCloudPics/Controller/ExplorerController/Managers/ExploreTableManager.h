//
//  PhotoTableManager.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshController.h"
#import "ExploreViewCell.h"

#import "SCPRequestManager.h"

@class SCPExplorerController;

@interface ExploreTableManager : NSObject <UITableViewDataSource, PullingRefreshDelegate, BannerDataSoure,ExploreCellDelegate,UIAlertViewDelegate>
{
    SCPRequestManager * _requestManager;
    NSMutableArray *_strategyArray;
    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    NSUInteger _lastCount;
}

@property (assign) BOOL isLoading;
@property (assign) SCPExplorerController *controller;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)refreshData:(id)sender;
@end
