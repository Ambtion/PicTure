//
//  SCPAlbumListCell.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPAlbumListCell.h"
#import "UIUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "SCPAlbum.h"


#define NAME_RECT CGRectMake(105, 12, 200, 40)
#define VIEWCOUNT_RECT CGRectMake(105, 50, 120, 12)
#define UPDATEDESC_RECT CGRectMake(230, 50, 75, 12)
#define PHOTONUM_RECT CGRectMake(105, 77, 200, 12)


@implementation SCPAlbumListCell

@synthesize photoImageView = _photoImageView;
@synthesize progressView = _progressView;
@synthesize deleteView = _deleteView;
@synthesize nameLabel = _nameLabel;
@synthesize photoNumLabel = _photoNumLabel;
@synthesize viewCountLabel = _viewCountLabel;
@synthesize updatedAtDescLabel = _updatedAtDescLabel;

@synthesize album = _album;

- (void)dealloc
{
    [_photoImageView release];
    [_progressView release];
    [_deleteView release];
    [_nameLabel release];
    [_photoNumLabel release];
    [_viewCountLabel release];
	[_updatedAtDescLabel release];
	[_album release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 105);
        
        /* album frame image view */
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 95, 95)];
        frameImageView.image = [UIImage imageNamed:@"150.png"];
        [self addSubview:frameImageView];
        [frameImageView release];
        
        /* photo image view */
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 75, 75)];
        _photoImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)];
        [_photoImageView addGestureRecognizer:gesture];
        [gesture release];
        
        UILongPressGestureRecognizer*  l_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewLongPressed:)];
        l_gesture.minimumPressDuration = 0.5;
        [_photoImageView addGestureRecognizer:l_gesture];
        [l_gesture release];
        l_gesture = nil;
        
        [self addSubview:_photoImageView];
        
        /* progressView */
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 73, 64, 8)];
        [_progressView setProgressImage:[UIImage imageNamed:@"prog_done.png"]];
        [_progressView setTrackImage:[[UIImage imageNamed:@"prog_wait.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];
        _progressView.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_progressView];
        
        /* deleteView, not display first */
        _deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -2, 29, 29)];
        _deleteView.image = [UIImage imageNamed:@"album_delete.png"];
        _deleteView.hidden = YES;
        [self addSubview:_deleteView];
        
        /* photoNum label */
        _photoNumLabel = [[UILabel alloc] initWithFrame:PHOTONUM_RECT];
		_photoNumLabel.backgroundColor = [UIColor clearColor];
        _photoNumLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
		_photoNumLabel.font = [_photoNumLabel.font fontWithSize:10];
		_photoNumLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_photoNumLabel];
        
        /* name label */
        _nameLabel = [[UILabel alloc] initWithFrame:NAME_RECT];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
		_nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        /* view count label */
        _viewCountLabel = [[UILabel alloc] initWithFrame:VIEWCOUNT_RECT];
        _viewCountLabel.backgroundColor = [UIColor clearColor];
        _viewCountLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        _viewCountLabel.font = [_nameLabel.font fontWithSize:10];
        _viewCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_viewCountLabel];
        
		/* state label */
		_updatedAtDescLabel = [[UILabel alloc] initWithFrame:UPDATEDESC_RECT];
		_updatedAtDescLabel.backgroundColor = [UIColor clearColor];
		_updatedAtDescLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
		_updatedAtDescLabel.font = [_updatedAtDescLabel.font fontWithSize:10];
		_updatedAtDescLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:_updatedAtDescLabel];
    }
    return self;
}

#pragma mark - public method
- (void)updateViewWithAlbum:(SCPAlbum *)album preToDel:(BOOL)deleting
{
	self.album = album;
	
	/* set photo image */
	if (self.album.coverURL == nil || [self.album.coverURL isKindOfClass:[NSNull class]] || self.album.coverURL.length == 0) {
		[_photoImageView setImage:[self getEmptyFolderCoverImage]];
	} else {
        NSString * coverUrl  =[NSString stringWithFormat:@"%@_c70",_album.coverURL];
		[_photoImageView setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:nil options:0];
	}

    /* progress view */
    [_progressView setHidden:!self.album.isUploading];
    
    /* deleteView */
    _deleteView.hidden = !deleting;

    /* count label */
    [_photoNumLabel setHidden:self.album.isUploading];
    [_photoNumLabel setText:[NSString stringWithFormat:@"共有 %d 张图片", self.album.photoNum]];
	
	/* name label */
	_nameLabel.frame = NAME_RECT;
	[_nameLabel setText:[UIUtils pruneString:self.album.name toLength:29]];
	[_nameLabel sizeToFit];
	
	/* view count label */
	_viewCountLabel.frame = VIEWCOUNT_RECT;
    NSString * str = nil;
    if (self.album.permission) {
        str = [NSString stringWithFormat:@"公开专辑  %d次浏览",self.album.viewCount];
    }else{
        str = [NSString stringWithFormat:@"私有专辑  %d次浏览",self.album.viewCount];
    }
	[_viewCountLabel setText:str];
    
	/* state label */
	_updatedAtDescLabel.frame = UPDATEDESC_RECT;
	// TODO
	[_updatedAtDescLabel setText:self.album.updatedAtDesc];
}

@end
