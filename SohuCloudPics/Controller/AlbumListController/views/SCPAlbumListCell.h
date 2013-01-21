//
//  SCPAlbumListCell.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPAlbumCell.h"
#import "UIImageView+WebCache.h"
#import "SCPAlbum.h"


@interface SCPAlbumListCell : SCPAlbumCell

@property (strong, nonatomic) UIImageView * photoImageView;		// 封面
@property (strong, nonatomic) UIProgressView *progressView;		// 上传进度条
@property (strong, nonatomic) UIImageView *deleteView;			// 删除按钮
@property (strong, nonatomic) UILabel *photoNumLabel;			// 图片数
@property (strong, nonatomic) UILabel *nameLabel;				// 专辑名
@property (strong, nonatomic) UILabel *viewCountLabel;			// 浏览量
@property (strong, nonatomic) UILabel *updatedAtDescLabel;		// 状态（上传中/最新更新）

@property (strong, nonatomic) SCPAlbum *album;

- (void)updateViewWithAlbum:(SCPAlbum *)album preToDel:(BOOL)deleting;

@end
