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

@interface PlazeManager : NSObject <UITableViewDataSource, PullingRefreshDelegate, BannerDataSoure,ExploreCellDelegate>
{
    
    SCPRequestManager * _requestManager;
    NSMutableArray * _strategyArray;
    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    NSUInteger _lastCount;
}
@property (assign) BOOL isLoading;
@property (assign) SCPPlazeController *controller;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)refreshData:(id)sender;
@end
