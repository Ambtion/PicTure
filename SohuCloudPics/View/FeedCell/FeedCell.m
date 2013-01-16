//
//  FeedCell.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "FeedCell.h"
#import "UIImageView+WebCache.h"

#import "SCPPersonalPageViewController.h"

#define OFFSETY 2

@implementation FeedCellDataSource

@synthesize photoImage = _photoImage, portrailImage = _portrailImage, name = _name,
update = _update;
//@synthesize favourtecount = _favourtecount;
@synthesize isGif = _isGif;
//@synthesize allInfo = _allInfo;
@synthesize heigth = _heigth;

- (void)dealloc
{
    self.photoImage = nil;
    self.portrailImage = nil;
    self.update = nil;
    self.name = nil;
    self.allInfo = nil;
    [super dealloc];
}

@end

enum {
    MyLike = 0,
    NotMyLick
};

@implementation FeedCell
@synthesize delegate = _delegate;
@synthesize maxImageHeigth = _maxImageHeigth;
@synthesize photoImageView = _photoImageView;
@synthesize gifPlayButton = _gifPlayButton;
- (void)dealloc
{
    [_photoImageView release];
    [tailerView release];
    [_portraitView release];
    [_nameLabel release];
    [_positionTimeLabel release];
    //    [_favorButton release];
    //    [_commentButton release];
    [_dataSource release];
    [_gifPlayButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addsubViews];
    }
    return self;
}

- (void)addsubViews
{
    [self addPhotoImageView];
    [self addtailer];
}

- (void)addPhotoImageView
{
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)] autorelease];
    view.backgroundColor = [UIColor colorWithRed:250.f/255 green:250.f/255 blue:250.f/255 alpha:1];
    view.clipsToBounds = YES;
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _photoImageView.backgroundColor = [UIColor clearColor];
    _photoImageView.userInteractionEnabled = YES;
    [_photoImageView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoImageViewClicked)] autorelease]];
    [view addSubview:_photoImageView];
    [self.contentView addSubview:view];
    
}
- (void)addtailer
{
    
    tailerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, 70)] autorelease];
    tailerView.backgroundColor = [UIColor clearColor];
    UIImageView * bg_imageview = [[[UIImageView alloc] initWithFrame:tailerView.bounds] autorelease];
    bg_imageview.image = [UIImage imageNamed:@"photo_user_info.png"];
    [tailerView addSubview:bg_imageview];
    
    _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5 , 50, 50)];
    _portraitView.userInteractionEnabled = YES;
    _portraitView.backgroundColor = [UIColor clearColor];
    UIGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitViewClicked:)] autorelease];
    [_portraitView addGestureRecognizer:tap];
    [tailerView addSubview:_portraitView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5 + OFFSETY, 230, 20)];
    _nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20];
    _nameLabel.textColor = [UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1];
    _nameLabel.numberOfLines = 1;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setUserInteractionEnabled:YES];
     UIGestureRecognizer * nameTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitViewClicked:)] autorelease];
    [_nameLabel addGestureRecognizer:nameTap];
    [tailerView addSubview:_nameLabel];

    _positionTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85 - 20, 32.5 + OFFSETY, 150, 14)];
    _positionTimeLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    _positionTimeLabel.textColor = [UIColor colorWithRed:97.0/255 green:120.0/255 blue:137.0/255 alpha:1];
    _positionTimeLabel.backgroundColor = [UIColor clearColor];
    [tailerView addSubview:_positionTimeLabel];
    
    //    _favorButton = [[MyFavouriteView alloc] initWithFrame:CGRectMake(205 - 7, 5 + OFFSETY, 51, 18)];
    //    _favorButton = [[MyFavouriteView alloc] initWithFrame:CGRectMake(266 - 7, 5 + OFFSETY, 51, 18)];
    //    [_favorButton addtarget:self action:@selector(favorButtonClicked)];
    //    [tailerView addSubview:_favorButton];
    //    _commentButton = [[MyFavouriteView alloc] initWithFrame:CGRectMake(266 - 7, 5 + OFFSETY, 51, 18)];
    //    [_commentButton addtarget:self action:@selector(commentButtonClicked)];
    //    _commentButton.imageView.image = [UIImage imageNamed:@"comments.png"];
    //    [tailerView addSubview:_commentButton];
    [self.contentView addSubview:tailerView];
}

#pragma mark -
#pragma mark updataData
- (void)showGifButton
{
    if (_dataSource.isGif) {
        if (!_gifPlayButton) {
            _gifPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,65, 65)];
            [_gifPlayButton setImage:[UIImage imageNamed:@"GIF_play_normal.png"] forState:UIControlStateNormal];
            [_gifPlayButton setImage:[UIImage imageNamed:@"GIF_play_press.png"] forState:UIControlStateHighlighted];
            [_gifPlayButton addTarget:self action:@selector(photoImageViewClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        _gifPlayButton.center = CGPointMake(_photoImageView.superview.bounds.size.width /2.f, _photoImageView.superview.bounds.size.height/ 2.f);
        if (!_gifPlayButton.superview)
            [_photoImageView.superview addSubview:_gifPlayButton];
    }else{
        if (_gifPlayButton.superview)
            [_gifPlayButton removeFromSuperview];
    }
}
- (void)updataData
{
    
    CGFloat widht = [[[self.dataSource allInfo] objectForKey:@"width"] floatValue];
    CGFloat height = [[[self.dataSource allInfo] objectForKey:@"height"] floatValue];
    if (widht <= 320 && height <= 320) {
        _photoImageView.frame = CGRectMake(0, 0, 320, 320);
        _photoImageView.center = CGPointMake(160, 160);
    }
    if (widht > 320 && height <= 320) {
        _photoImageView.frame = CGRectMake(0, 0, 320 , 320);
        _photoImageView.center = CGPointMake(160, 160);
    }
    if (widht <= 320 && height > 320) {
        _photoImageView.frame = CGRectMake(0, 0, 320,320);
        _photoImageView.center = CGPointMake(160, 160);
    }
    if (widht > 320 && height > 320 ) {
        _photoImageView.frame = CGRectMake(0, 0, 320, 320);
        _photoImageView.center = CGPointMake(160, 160);
    }
    [_photoImageView cancelCurrentImageLoad];
    NSString * str = [NSString stringWithFormat:@"%@_c640",_dataSource.photoImage];
    [_photoImageView setImageWithURL:[NSURL URLWithString:str]];

    [self showGifButton];
    
    if (!_dataSource ||![_dataSource.name isKindOfClass:[NSString class]] || [_dataSource.name isEqualToString:@""]) {
        _nameLabel.text = @"佚名";
    }else{
        _nameLabel.text = [_dataSource name];
    }
    if (!_dataSource.update ||![_dataSource.update isKindOfClass:[NSString class]] || [_dataSource.update isEqualToString:@""]) {
        _positionTimeLabel.text = @"时间未知";
    }else{
        _positionTimeLabel.text = [NSString stringWithFormat:@"%@上传",_dataSource.update];
    }
    [_portraitView setImageWithURL:[NSURL URLWithString:_dataSource.portrailImage] placeholderImage:[UIImage imageNamed:@"portrait_default.png"] success:^(UIImage *image) {
        if (!image || !image.size.width)
            _portraitView.image = [UIImage imageNamed:@"portrait_default.png"];
    } failure:^(NSError *error) {
        _portraitView.image = [UIImage imageNamed:@"portrait_default.png"];
    }];
}
- (FeedCellDataSource *)dataSource
{
    return _dataSource;
}
- (void)setDataSource:(FeedCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataData];
    }
}

#pragma mark -
#pragma mark FeedCellDelegate

- (void)photoImageViewClicked
{
    
    if ([_delegate respondsToSelector:@selector(feedCell:clickedAtPhoto:)]) {
        [self.delegate feedCell:self clickedAtPhoto:nil];
    }
}

- (void)portraitViewClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(feedCell:clickedAtPortraitView:)]) {
        [self.delegate feedCell:self clickedAtPortraitView:sender];
    }
}

- (void)favorButtonClicked
{
    //    [self setFavorButtonImage];
    //     _dataSource.ismyLike = !_dataSource.ismyLike;
    if ([_delegate respondsToSelector:@selector(feedCell:clickedAtFavorButton:)]) {
        [self.delegate feedCell:self clickedAtFavorButton:nil];
    }
}

- (void)commentButtonClicked
{
    if ([_delegate respondsToSelector:@selector(feedCell:clickedAtCommentButton:)]) {
        [self.delegate feedCell:self clickedAtCommentButton:nil];
    }
}

@end
