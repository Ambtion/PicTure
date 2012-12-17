//
//  SCPFollowCommonCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewForCell.h"

@class SCPFollowCommonCell;
typedef  enum  {
    FLLOW_ME = 0,
    FLLOW_BUYME = 1,
    FLLOW_TOGETHER = 2,
    FLLOW_NONE = 3
}FLLOW_STATE;

@interface SCPFollowCommonCellDataSource : NSObject
@property(nonatomic,retain)NSDictionary * allInfo;
@property(nonatomic,retain)NSString  * coverImage;
@property(nonatomic,retain)NSString * title;
@property(nonatomic,assign)NSInteger pictureCount;
@property(nonatomic,assign)NSInteger albumCount;
@property(nonatomic,assign)FLLOW_STATE fllowState;
@end

@protocol SCPFollowCommonCellDelegate <NSObject>
-(void)follweCommonCell:(SCPFollowCommonCell *)cell followButton:(UIButton*)button;
-(void)follweCommonCell:(SCPFollowCommonCell *)cell followImage:(id)image;

@end

@interface SCPFollowCommonCell : UITableViewCell
{
    ImageViewForCell * _imageCoverView;
    UILabel * _descLabel;
    UILabel * _titleLabel;
    UIButton * _follweButton;
}
@property(nonatomic,retain)SCPFollowCommonCellDataSource * dataSource;
@property(nonatomic,assign)id<SCPFollowCommonCellDelegate> delegate;
@end
