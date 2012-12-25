//
//  NoticeManager.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import "NoticeViewController.h"
#import "NoticeViewCell.h"
#import "SCPRequestManager.h"

@class NoticeViewController;
@interface NoticeManager : NSObject<UITableViewDataSource,PullingRefreshDelegate,BannerDataSoure,NoticeViewCellDelegate,SCPRequestManagerDelegate>
{
    NSMutableArray * _dataSource;
    BOOL _isLoading;
    SCPRequestManager * _resqust;
}
@property (assign, nonatomic) NoticeViewController *controller;

- (id)initWithViewController:(NoticeViewController *)ctrl;
- (void)refreshData:(id)sender;
@end
