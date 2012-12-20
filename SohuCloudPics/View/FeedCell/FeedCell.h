//
//  FeedCell.h
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavouriteView.h"


@class FeedCell;
@protocol FeedCellDelegate <NSObject>

@required

- (void)feedCell:(FeedCell *)cell clickedAtPhoto:(id)object;
- (void)feedCell:(FeedCell *)cell clickedAtPortraitView:(id)object;
- (void)feedCell:(FeedCell *)cell clickedAtFavorButton:(id)object;
- (void)feedCell:(FeedCell *)cell clickedAtCommentButton:(id)objectx;
@end


@interface FeedCellDataSource : NSObject

@property(nonatomic,retain)NSDictionary * allInfo;//为了更好的传参,代价是内存占用

@property(nonatomic,assign)CGFloat  heigth;
@property(nonatomic,retain)NSString * photoImage;
@property(nonatomic,assign)BOOL isGif;
@property(nonatomic,retain)NSString * portrailImage;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * update;

//@property(nonatomic,retain)NSString * position;
@property(nonatomic,assign)NSInteger favourtecount;
//@property(nonatomic,assign)NSInteger commontcount;
@property(nonatomic,assign)BOOL ismyLike;
@end

@interface FeedCell : UITableViewCell
{
    
    UIImageView* _photoImageView;
    //tailerview
    UIView * tailerView;
    UIImageView* _portraitView;
    UILabel*  _nameLabel;
    UILabel * _positionTimeLabel;
    MyFavouriteView * _favorButton;
    MyFavouriteView * _commentButton;
    FeedCellDataSource * _dataSource;
    UIImageView * _gifPlayView;
    UIWebView * _webView;

}
//@property (strong, nonatomic) NSObject <FeedCellDataSource> *dataSource;
@property (assign, nonatomic) id <FeedCellDelegate> delegate;
@property (nonatomic,retain) FeedCellDataSource * dataSource;
@property (nonatomic,assign)CGFloat maxImageHeigth;
@property (nonatomic,retain)UIImageView * photoImageView;
- (void)photoImageViewClicked;

@end





