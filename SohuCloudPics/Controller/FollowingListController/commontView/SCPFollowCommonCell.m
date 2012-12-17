//
//  SCPFollowCommonCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPFollowCommonCell.h"
#import "UIImageView+WebCache.h"

static NSString * FLLOW_PICTURE[4] = {@"list_follow_me_icon.png",@"list_follower-icon.png",@"list_following-icon.png",@"list-unfollow-icon.png"};

@implementation SCPFollowCommonCellDataSource
@synthesize allInfo = _allInfo;
@synthesize coverImage = _coverImage;
@synthesize title = _title;
@synthesize pictureCount = _pictureCount,albumCount = _albumCount,fllowState = _fllowState;
- (void)dealloc
{
    self.coverImage = nil;
    self.title = nil;
    self.allInfo = nil;
    [super dealloc];
}
@end

@implementation SCPFollowCommonCell
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 60);
        [self addSubviews];
    }
    return self;
}
- (void)dealloc
{
    [_dataSource release];
    [_imageCoverView release];
    [_titleLabel release];
    [_descLabel release];
    [_follweButton release];
    [super dealloc];
}

-(void)addSubviews
{
    _imageCoverView = [[ImageViewForCell alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    _imageCoverView.backgroundColor = [UIColor clearColor];
    [_imageCoverView addTarget:self action:@selector(follweImageCick:)];
    [self.contentView addSubview:_imageCoverView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 15)];
    _titleLabel.textAlignment = UITextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _titleLabel.textColor = [UIColor colorWithRed:97.f/255 green:120.f/255 blue:137.f/255 alpha:2];
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 200, 12)];
    _descLabel.textAlignment = UITextAlignmentLeft;
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _descLabel.textColor = [UIColor colorWithRed:98.f/255 green:98.f/255 blue:98.f/255 alpha:1];
    [self.contentView addSubview:_descLabel];
    
    _follweButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _follweButton.frame = CGRectMake(286, 16, 28, 28);
    [_follweButton addTarget:self action:@selector(follweButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_follweButton];
    UIImageView * lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    lineView.frame = CGRectMake(0, 59, 320, 1);
    [self.contentView addSubview:lineView];
    [lineView release];
    
}
-(void)updataData
{
    [_imageCoverView setImageWithURL:[NSURL URLWithString:_dataSource.coverImage] placeholderImage:[UIImage imageNamed:@"user_bg_photo_defout.png"]];
    if (_dataSource.title && ![_dataSource.title isKindOfClass:[NSNull class]] && ![[_dataSource title] isEqualToString:@""]) {
        _titleLabel.text = _dataSource.title;
    }else{
        _titleLabel.text = @"用户没起名";
    }
    _descLabel.text = [NSString stringWithFormat:@"%d张图片, %d个相册",_dataSource.pictureCount,_dataSource.albumCount];
    [_follweButton setBackgroundImage:[UIImage imageNamed:FLLOW_PICTURE[_dataSource.fllowState]] forState:UIControlStateNormal];
}
-(void)setDataSource:(SCPFollowCommonCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataData];
    }
}
-(SCPFollowCommonCellDataSource *)dataSource
{
    return _dataSource;
}
#pragma mark -
#pragma mark action
-(void)follweButtonClick:(UIButton*)button
{
    if ([_delegate respondsToSelector:@selector(follweCommonCell:followButton:)]) {
        [_delegate follweCommonCell:self followButton:button];
    }
}
-(void)follweImageCick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(follweCommonCell:followImage:)]) {
        [_delegate follweCommonCell:self followImage:sender];
    }
}
@end
