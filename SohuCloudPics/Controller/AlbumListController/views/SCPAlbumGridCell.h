//
//  SCPAlbumCell.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPAlbumCell.h"
#import "UIImageView+WebCache.h"
#import "SCPAlbum.h"


#define GRID_CELL_HEIGHT 125


@interface SCPAlbumGridCell : SCPAlbumCell

@property (strong, nonatomic) NSMutableArray *coverImageViewList;
@property (strong, nonatomic) NSMutableArray *frameImageViewList;
@property (strong, nonatomic) NSMutableArray *progressViewList;
@property (strong, nonatomic) NSMutableArray *nameLabelList;
@property (strong, nonatomic) NSMutableArray *countLabelList;
@property (strong, nonatomic) NSMutableArray *deleteViewList;
@property (strong, nonatomic) NSMutableArray *albumList;

@property (assign, nonatomic) int photoCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier photoCount:(int)count;

- (UIImageView *)coverImageViewAt:(int)position;
- (UILabel *)nameLabelAt:(int)position;
- (UIImageView *)deleteViewAt:(int)position;
- (UIProgressView *)progressViewAt:(int)position;
- (void)hideAllViews;
- (void)updateViewWithAlbum:(SCPAlbum *)album position:(int)position preToDel:(BOOL)deleting;

@end
