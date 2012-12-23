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

@class SCPPersonalPageViewController;
@interface PersonalPageManager : NSObject <UITableViewDataSource, PullingRefreshTableViewDelegate, FeedCellDelegate, PersonalPageCellDelegate, SCPRequestManagerDelegate, UIAlertViewDelegate,SCPAlertLoginViewDelegate,SCPLoginViewDelegate>
{
    NSMutableArray* _dataArray;
    SCPRequestManager  * _requestManager;
    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    NSString * _user_ID;
    BOOL _loadingMore;
    PersonalPageCellDateSouce * _personalDataSource;
    BOOL hasNextpage;
    NSInteger curPage;
}

@property (assign, nonatomic) SCPPersonalPageViewController *controller;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (id)initWithController:(SCPPersonalPageViewController *)ctrl useID:(NSString *)useID;

- (void)loadingMore:(id)sender;
- (void)showLoadingMore;
@end
