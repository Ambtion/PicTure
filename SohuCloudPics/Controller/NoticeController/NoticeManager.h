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


@class NoticeViewController;
@interface NoticeManager : NSObject<UITableViewDataSource,PullingRefreshDelegate,BannerDataSoure,NoticeViewCellDelegate>
{
    NSMutableArray * _dataSource;
    BOOL _isLoading;
}
@property (assign, nonatomic) NoticeViewController *controller;

- (id)initWithViewController:(NoticeViewController *)ctrl;
- (void)refreshData:(id)sender;
@end
