//
//  PersonalPageManager.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-29.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshTableView.h"

#import "FeedCell.h"
#import "PersonalPageCell.h"
#import "SCPRequestManager.h"
#import "SCPAlert_LoginView.h"
#import "SCPLoginViewController.h"
#import "SCPAlert_WaitView.h"

@class SCPPersonalHomeController;
@interface PersonalHomeManager : NSObject <UITableViewDataSource, PullingRefreshTableViewDelegate, FeedCellDelegate, PersonalPageCellDelegate, SCPRequestManagerDelegate, UIAlertViewDelegate,SCPAlertLoginViewDelegate,SCPLoginViewDelegate>
{
    NSMutableArray* _dataArray;
    SCPRequestManager  * _requestManager;
    SCPAlert_WaitView * wait;
    PersonalPageCellDateSouce * _personalDataSource;
    NSString * _user_ID;

    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    BOOL _loadingMore;
    BOOL hasNextpage;
    NSInteger curPage;
}

@property (assign, nonatomic) SCPPersonalHomeController *controller;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (id)initWithController:(SCPPersonalHomeController *)ctrl useID:(NSString *)useID;
- (void)loadingMore:(id)sender;
- (void)showLoadingMore;
@end
