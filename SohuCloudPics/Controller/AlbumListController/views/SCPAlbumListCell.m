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


#define NAME_RECT CGRectMake(105, 12, 200, 38)
#define VIEWCOUNT_RECT CGRectMake(105, 52, 120, 12)
#define UPDATEDESC_RECT CGRectMake(230, 50, 75, 12)
#define PHOTONUM_RECT CGRectMake(105, 77 - 8, 200, 12)


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
        self.frame = CGRectMake(0, 0, 320, 100);
        /* album frame image view */
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 95, 95)];
        frameImageView.image = [UIImage imageNamed:@"150.png"];
        [frameImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:frameImageView];
        [frameImageView release];
        
        /* photo image view */
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        _photoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)];
        [_photoImageView addGestureRecognizer:gesture];
        [gesture release];
        
        UILongPressGestureRecognizer*  l_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewLongPressed:)];
        l_gesture.minimumPressDuration = 0.5;
        [_photoImageView addGestureRecognizer:l_gesture];
        [l_gesture release];
        l_gesture = nil;
        
        [frameImageView addSubview:_photoImageView];
		
        /* progressView */
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 73, 64, 9)];
        [_progressView setProgressImage:[[UIImage imageNamed:@"prog_done.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];
        [_progressView setTrackImage:[[UIImage imageNamed:@"prog_wait.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)]];

        [self.contentView addSubview:_progressView];
        /* deleteView, not display first */
        _deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -2, 29, 29)];
        _deleteView.image = [UIImage imageNamed:@"album_delete.png"];
		_deleteView.userInteractionEnabled = YES;
        _deleteView.hidden = YES;
		
		UITapGestureRecognizer *d_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)];
		[_deleteView addGestureRecognizer:d_gesture];
		[d_gesture release];
		
        [self.contentView addSubview:_deleteView];
        
        /* photoNum label */
        _photoNumLabel = [[UILabel alloc] initWithFrame:PHOTONUM_RECT];
		_photoNumLabel.backgroundColor = [UIColor clearColor];
        _photoNumLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
		_photoNumLabel.font = [_photoNumLabel.font fontWithSize:10];
		_photoNumLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_photoNumLabel];
        
        /* name label */
        _nameLabel = [[UILabel alloc] initWithFrame:NAME_RECT];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
		_nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.numberOfLines = 2;
        UITapGestureRecognizer * nameTap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)] autorelease];
        [_nameLabel setUserInteractionEnabled:YES];
        [_nameLabel addGestureRecognizer:nameTap];
        [self.contentView addSubview:_nameLabel];
        
        /* view count label */
        _viewCountLabel = [[UILabel alloc] initWithFrame:VIEWCOUNT_RECT];
        _viewCountLabel.backgroundColor = [UIColor clearColor];
        _viewCountLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        _viewCountLabel.font = [_nameLabel.font fontWithSize:10];
        _viewCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_viewCountLabel];
        
		/* state label */
		_updatedAtDescLabel = [[UILabel alloc] initWithFrame:UPDATEDESC_RECT];
		_updatedAtDescLabel.backgroundColor = [UIColor clearColor];
		_updatedAtDescLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
		_updatedAtDescLabel.font = [_updatedAtDescLabel.font fontWithSize:10];
		_updatedAtDescLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_updatedAtDescLabel];
        
        UIImageView * lineView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]] autorelease];
        lineView.frame = CGRectMake(0, self.frame.size.height - 1, 320, 1);
        [self.contentView addSubview:lineView];
    }
    return self;
}

#pragma mark - public method
- (void)updateViewWithAlbum:(SCPAlbum *)album preToDel:(BOOL)deleting
{
    
	self.album = album;
	/* set photo image */
	if (self.album.coverURL == nil || [self.album.coverURL isKindOfClass:[NSNull class]] || self.album.coverURL.length == 0) {
        _photoImageView.image =[UIImage imageNamed:@"frame_alubme_default_image.png"];
	} else {
        NSString * coverUrl  =[NSString stringWithFormat:@"%@_c150",_album.coverURL];
		[_photoImageView setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:nil options:0];
	}
    /* progress view */
    [_progressView setHidden:!self.album.isUploading];
    
    /* deleteView */
    _deleteView.hidden = !deleting;

    /* count label */
    [_photoNumLabel setHidden:self.album.isUploading];
    [_photoNumLabel setText:[NSString stringWithFormat:@"共有%d张图片", self.album.photoNum]];
	
	/* name label */
	_nameLabel.frame = NAME_RECT;
    _nameLabel.text = [self.album name];
	
	/* view count label */
	_viewCountLabel.frame = VIEWCOUNT_RECT;
    NSString * str = nil;
    if (self.album.permission) {
        str = [NSString stringWithFormat:@"公开专辑  %d次浏览",self.album.viewCount];
    }else{
        str = [NSString stringWithFormat:@"私密专辑  %d次浏览",self.album.viewCount];
    }
    
	[_viewCountLabel setText:str];
	/* state label */
	_updatedAtDescLabel.frame = UPDATEDESC_RECT;
	// TODO
	[_updatedAtDescLabel setText:self.album.updatedAtDesc];
}

@end
