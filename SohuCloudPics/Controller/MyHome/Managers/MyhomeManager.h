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

@class SCPMyHomeViewController;
@interface MyhomeManager : NSObject
<UITableViewDataSource,MyPersonalCellDelegate,FeedCellDelegate,UITableViewDelegate,SCPRequestManagerDelegate>
{
    NSMutableArray* _dataArray;
    SCPRequestManager  * _requestManager;
    BOOL _isLoading;
    BOOL _willRefresh;
    BOOL _isinit;
    NSString * _user_ID;
    BOOL _loadingMore;
    MyPersonalCelldataSource * _personalDataSource;
    BOOL hasNextpage;
    NSInteger curPage;
}
@property (assign, nonatomic) SCPMyHomeViewController *controller;
- (id)initWithController:(SCPMyHomeViewController *)ctrl useID:(NSString *)useID;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
- (void)loadingMore:(id)sender;
@end
