//
//  FeedCell.h
//  sohu_yuntu
//
//  Created by Sheng Zhong on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedCellDataSource <NSObject>
@required
- (NSString *)name;
- (NSString *)position;
- (NSString *)title;
- (NSDate *)time;
- (UIImage *)portrait;
- (UIImage *)photo;
- (NSInteger)favorAmount;
- (NSInteger)commentAmount;
@end



@class FeedCellTailer;
@protocol FeedCellTailerDelegate <NSObject>
@required
- (void)feedCellTailer:(FeedCellTailer *)tailer clickedAt:(NSInteger)index;
@end




@interface FeedCellTailer : UIView

@property (strong, nonatomic) NSObject <FeedCellDataSource> *dataSource;
@property (strong, nonatomic) NSObject <FeedCellTailerDelegate> *delegate;

@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *positionTimeLabel;
@property (strong, nonatomic) UIButton *favorButton;
@property (strong, nonatomic) UIButton *commentButton;

- (void)clicked;

@end




@interface FeedCell : UITableViewCell

@property (strong, nonatomic) NSObject <FeedCellDataSource> *dataSource;

@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) FeedCellTailer *tailer;

@end





