//
//  MyHomeManager.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <Foundation/Foundation.h>

#import "MyPersonalCell.h"
#import "FeedCell.h"
#import "SCPRequestManager.h"
#import "SCPAlert_WaitView.h"

@class SCPMyHomeController;

@interface MyHomeManager : NSObject<UITableViewDataSource,MyPersonalCellDelegate,
                            FeedCellDelegate,UITableViewDelegate,SCPRequestManagerDelegate,UIAlertViewDelegate>
{
    NSMutableArray* _dataArray;
    SCPRequestManager  * _requestManager;
    MyPersonalCelldataSource * _personalDataSource;
    NSString * _user_ID;
    SCPAlert_WaitView * _wait;
    
    NSInteger _curPage;
    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    BOOL _loadingMore;
    BOOL _hasNextpage;
}

@property (assign, nonatomic) SCPMyHomeController *controller;
- (id)initWithController:(SCPMyHomeController *)ctrl useID:(NSString *)useID;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)loadingMore:(id)sender;
- (void)refreshUserinfo;
@end
