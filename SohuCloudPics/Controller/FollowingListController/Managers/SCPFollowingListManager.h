//
//  SCPFollowingListManager.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshController.h"
#import "SCPFollowCommonCell.h"
#import "SCPRequestManager.h"


@class SCPFollowingListViewController;
@interface SCPFollowingListManager : NSObject<PullingRefreshDelegate,BannerDataSoure,UITableViewDataSource,SCPFollowCommonCellDelegate,SCPRequestManagerDelegate>
{
    NSMutableArray * _dataSource;
    SCPRequestManager * _requestManger;
    BOOL _isLoading;
    BOOL _isinit;
    BOOL _willRefresh;
    NSString * _user_ID;
    NSInteger _maxNum;

}

@property (assign, nonatomic) SCPFollowingListViewController *controller;

- (id)initWithViewController:(SCPFollowingListViewController *)ctrl useID:(NSString *)useID;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)refreshData:(id)sender;
@end
