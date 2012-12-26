//
//  NoticeViewCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "ImageViewForCell.h"
#import "UIImageView+WebCache.h"

@interface NoticeDataSource : NSObject

@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * upTime;
@property(nonatomic,retain) NSString * photoUrl;
@property(nonatomic,retain) UIImage * image;
@end
@class NoticeViewCell;
@protocol NoticeViewCellDelegate <NSObject>
- (void)NoticeViewCell:(NoticeViewCell * )cell portraitClick:(id)sender;
@end
@interface NoticeViewCell : UITableViewCell
{
    ImageViewForCell * _imageCoverView;
    UILabel * _descLabel;
    UILabel * _titleLabel;
    UILabel * _timeLabel;
}
@property(nonatomic,retain)NoticeDataSource * dataSource;
@property(nonatomic,assign)id<NoticeViewCellDelegate> delegate;
@end
