//
//  CommentCell.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentCell;
@protocol CommentCellDelegate <NSObject>
@required
- (void)commentCell:(CommentCell *)cell portraitViewClickedWith:(id)object;
@end


@interface CommentCellDataSource : NSObject
@property(nonatomic,retain)UIImage * portraitImage;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * content;
@property(nonatomic,retain)NSString * time;
@end

@interface CommentCell : UITableViewCell
{
    UIImageView * _portraitImageView;
    UILabel * _nameLabel;
    UILabel * _contentLabel;
    UILabel * _timeLabel;
    
    CommentCellDataSource * _dataSource;
}
@property (nonatomic,retain)CommentCellDataSource * dataSource;
@property (nonatomic,assign) id<CommentCellDelegate>  delegate;

- (void)portraitViewClicked;

@end
