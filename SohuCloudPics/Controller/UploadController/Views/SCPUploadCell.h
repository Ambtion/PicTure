//
//  SCPUploadCell.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "SCPUploadController.h"


#define DESC_COUNT_LIMIT 144



@interface SCPUploadCell : UITableViewCell <UITextViewDelegate>
{
    UIImage *_desc_back_img;
}

@property (assign, nonatomic) SCPUploadController *uploadController;

@property (strong, nonatomic) UIImageView *portraitImageView;
@property (strong, nonatomic) UIImageView *descBackgroundImageView;
@property (strong, nonatomic) UITextView *descTextView;
@property (strong, nonatomic) UILabel *descCountLabel;

@end
