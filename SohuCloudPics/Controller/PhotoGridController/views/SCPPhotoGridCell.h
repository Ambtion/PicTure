//
//  SCPPhotoGridCell.h
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-24.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SCPAlbum.h"
#import "SCPPhoto.h"


@protocol SCPPhotoGridCellDelegate <NSObject>
@optional
- (void)onImageViewClicked:(UIImageView *)imageView;
@end


@interface SCPPhotoGridCell : UITableViewCell

/* Data */
//@property (strong, nonatomic) NSMutableArray *imageIdList;

/* UI */
@property (strong, nonatomic) NSMutableArray *imageViewList;
@property (strong, nonatomic) NSMutableArray *progViewList;
@property (strong, nonatomic) NSMutableArray *deleteViewList;

@property (assign, nonatomic) id <SCPPhotoGridCellDelegate> delegate;

- (UIImageView *)imageViewAt:(int)position;
- (UIProgressView *)progressViewAt:(int)position;

- (void)updateViewWithTask:(SCPPhoto*)data Position:(int)position PreToDel:(BOOL)pre;
- (void)updateViewWithPhoto:(SCPPhoto *)photo Position:(int)position PreToDel:(BOOL)pre;
- (void)hideViewWithPosition:(int)position;

@end
