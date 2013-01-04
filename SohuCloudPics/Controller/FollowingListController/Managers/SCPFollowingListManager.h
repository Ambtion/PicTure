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
#import "SCPAlert_LoginView.h"
#import "SCPLoginViewController.h"

@class SCPFollowingListViewController;
@interface SCPFollowingListManager : NSObject<PullingRefreshDelegate,BannerDataSoure,UITableViewDataSource,SCPFollowCommonCellDelegate,SCPRequestManagerDelegate,SCPAlertLoginViewDelegate,SCPLoginViewDelegate>
{
    NSMutableArray * _dataSource;
    SCPRequestManager * _requestManger;
    
    BOOL _isLoading;
    BOOL _isinit;
    BOOL _willRefresh;
    NSString * _user_ID;
    NSInteger _maxNum;
    BOOL hasNext;
    NSInteger curPage;
}

@property (assign, nonatomic) SCPFollowingListViewController *controller;

- (id)initWithViewController:(SCPFollowingListViewController *)ctrl useID:(NSString *)useID;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)refreshData:(id)sender;
@end
