//
//  PersonalPageCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalPageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"


@implementation PersonalPageCellDateSouce

@synthesize isInit = _isInit;
@synthesize portrait = _portrait;
@synthesize name = _name;
//@synthesize position = _position;
@synthesize desc = _desc;

@synthesize isFollowByMe = _isFollowByMe;
@synthesize albumAmount = _albumAmount;
//@synthesize favouriteAmount = _favouriteAmount;
@synthesize followedAmount = _followedAmount;
@synthesize followingAmount = _followingAmount;
@synthesize isMe = _isMe;
- (id)init
{
    if (self = [super init]) {
        self.isInit = YES;
    }
    return self;
}
- (void)dealloc
{
    self.portrait = nil;
    self.name = nil;
//    self.allInfo = nil;
    self.desc = nil;
    [super dealloc];
}

@end
@class PersonalPageCell;
@implementation PersonalPageCell
@synthesize delegate = _delegate;
@synthesize datasource = _dataSource;
- (void)dealloc
{
    [_dataSource release];
    [_backgroundImageView release];
    [_portraitImageView release];
    [_nameLabel release];
    [_descLabel release];
    
    [_albumButton release];
    [_followingButton release];
    [_followedButton release];
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        //set cell height
        CGRect rect = self.frame;
        rect.size.height = 367 + 60;
        self.frame = rect;
        
        [self addUesrphotoView];
        [self addUserPhotoLabel];
        [self addMenuView];
    }
    return self;
}
-(void)addUesrphotoView
{
    //backGroud
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 367 - 480, 320, 480)];
    _backgroundImageView.image = [UIImage imageNamed:@"user_bg_soul.png"];
    [self.contentView addSubview:_backgroundImageView];
    
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(118 , 109, 85, 85)];
    _portraitImageView.layer.cornerRadius = 42.5;
    _portraitImageView.clipsToBounds = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_portraitImageView];
    
    bgCircleView = [[[UIImageView alloc] initWithImage:nil] autorelease];
    bgCircleView.frame = CGRectMake(109, 100, 102, 102);
    [self.contentView addSubview:bgCircleView];
}
-(void)addUserPhotoLabel
{
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 212, 300, 18)];
    _nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
    _nameLabel.shadowColor = [UIColor blackColor];
    _nameLabel.shadowOffset = (CGSize){0, 1};
    _nameLabel.textAlignment = UITextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 236, 300, 24)];
    _descLabel.font = [UIFont  fontWithName:@"STHeitiTC-Medium" size:12];
    _descLabel.textAlignment = UITextAlignmentCenter;
    _descLabel.numberOfLines = 2;
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.shadowColor = [UIColor blackColor];
    _descLabel.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:_descLabel];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.frame = CGRectMake(117, 268, 90, 25);
    _followButton.backgroundColor = [UIColor clearColor];
    [_followButton addTarget:self action:@selector(personalFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_followButton setHidden:YES];
    [self.contentView addSubview:_followButton];
    
    CGRect frame = CGRectMake(_backgroundImageView.frame.size.width - 36, _backgroundImageView.frame.size.height - 36 - 113 - 5, 35, 35);
    RefreshButton * refreshButton = [[[RefreshButton alloc] initWithFrame:frame] autorelease];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"header_user_refresh.png"] forState:UIControlStateNormal];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"header_user_refresh_press.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(personalrefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:refreshButton];

}
-(void)addMenuView
{
    
    UIImageView* bg_menu = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_menu.png"]] autorelease];
    bg_menu.frame = CGRectMake(0, 367, 320, 60);
    bg_menu.userInteractionEnabled = YES;
    [self.contentView addSubview:bg_menu];
    
    _albumButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 106, 60)];
    _albumButton.nameLabel.text = @"相册";
    _albumButton.delegate = self;
    [bg_menu addSubview:_albumButton];
    
    _followingButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(106, 0, 106, 60)];
    _followingButton.nameLabel.text = @"关注的人";
    _followingButton.delegate = self;
    [bg_menu addSubview:_followingButton];
    
    _followedButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(106 * 2, 0, 106, 60)];
    _followedButton.nameLabel.text = @"粉丝";
    _followedButton.delegate = self;
    [bg_menu addSubview:_followedButton];

}
- (void)updataData
{
    
    [_portraitImageView setImageWithURL:[NSURL URLWithString:_dataSource.portrait] placeholderImage:[UIImage imageNamed:@"user_bg_photo_defout.png"]];
    
    if (!_dataSource.name || ![_dataSource.name isKindOfClass:[NSString class]] || [_dataSource.name isEqualToString:@""]) {
        _nameLabel.text = @"佚名";
    }else{
        _nameLabel.text = [_dataSource name];
    }
    if (!_dataSource.desc ||[_dataSource.desc isKindOfClass:[NSNull class]] || [_dataSource.desc isEqualToString:@""]) {
        _descLabel.text = @"用户没有描述";
    }else{
        _descLabel.text = self.datasource.desc;
    }
    if (self.datasource.isFollowByMe) {
        [_followButton setImage:[UIImage imageNamed:@"user_cancel_follow_normal-2.png"] forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"user_cancel_follow_press_2.png"] forState:UIControlStateHighlighted];
    }else{
        [_followButton setImage:[UIImage imageNamed:@"user_add_following_normal.png"] forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"user_add_following_press.png"] forState:UIControlStateHighlighted];
    }
    _albumButton.numlabel.text = [NSString stringWithFormat:@"%d", self.datasource.albumAmount];
    _followingButton.numlabel.text = [NSString stringWithFormat:@"%d", self.datasource.followingAmount];
    _followedButton.numlabel.text  = [NSString stringWithFormat:@"%d", self.datasource.followedAmount];
    
    
    if (self.datasource.isInit) {
        _portraitImageView.image = nil;
        _nameLabel.text = nil;
        _descLabel.text = nil;
        [_followButton setHidden:YES];
        _albumButton.numlabel.text = nil;
        _followingButton.numlabel.text = nil;
        _followedButton.numlabel.text = nil;
    }else{
        [_followButton setHidden:NO];
        bgCircleView.image = [UIImage imageNamed:@"user_bg_photo.png"];
    }
    
    if (self.datasource.isMe ) {
        [_followButton setHidden:YES];
    }else{
        [_followButton setHidden:NO];
    }
}

-(void)setDatasource:(PersonalPageCellDateSouce *)datasource
{
    if (_dataSource != datasource) {
        [_dataSource release];
        _dataSource = [datasource retain];
    }
    [self updataData];
}
#pragma mark -
#pragma mark funcitonClick
- (void)personalFollowButton:(UIButton *)button
{

//    self.datasource.isFollowed = !self.datasource.isFollowed;
//    if (self.datasource.isFollowed) {
//        [_followButton setTitle:@"取消跟随" forState:UIControlStateNormal];
//    }else{
//        [_followButton setTitle:@"跟随对方" forState:UIControlStateNormal];
//    }
    if ([_delegate respondsToSelector:@selector(personalPageCell:follwetogether:)]) {
        [_delegate personalPageCell:self follwetogether:button];
    }
}
- (void)personalrefreshButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(personalPageCell:refreshClick:)]) {
        [_delegate personalPageCell:self refreshClick:button];
    }
}

#pragma mark -
#pragma menuButtonviewMethod
-(void)menu:(MenuButtonView *)menuView ButtonClick:(UITapGestureRecognizer *)gesture
{
    if ([menuView isEqual:_albumButton]) {
        [self photoBookClick:gesture];
    }else
//        if ([menuView isEqual:_favorButton]) {
//        [self favoriteButtonClicked:gesture];
//    }else
        if ([menuView isEqual:_followedButton]) {
        [self followedButtonClicked:gesture];
    }else {
        [self followingButtonClicked:gesture];
    }
}

#pragma makr -
#pragma mark ButtonClick-Method
-(void)photoBookClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(personalPageCell:photoBookClicked:)]) {
        [_delegate personalPageCell:self photoBookClicked:sender];
    }
    
}
- (void)favoriteButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(personalPageCell:favoriteClicked:)]) {
        [_delegate personalPageCell:self favoriteClicked:sender];
    }
}
- (void)followingButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(personalPageCell:followingButtonClicked:)]) {
        [_delegate personalPageCell:self followingButtonClicked:sender];
    }
}

- (void)followedButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(personalPageCell:followedButtonClicked:)]) {
        [_delegate personalPageCell:self followedButtonClicked:sender];
    }
}


@end
