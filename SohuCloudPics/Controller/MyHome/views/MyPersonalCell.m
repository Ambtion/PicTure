//
//  MyPersonalCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "MyPersonalCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation MyPersonalCelldataSource
@synthesize allInfo = _allInfo;
@synthesize portrait = _portrait;
@synthesize name = _name;
@synthesize position = _position;
@synthesize desc = _desc;
@synthesize albumAmount = _albumAmount;
//@synthesize favouriteAmount = _favouriteAmount;
@synthesize followedAmount = _followedAmount;
@synthesize followingAmount = _followingAmount;

- (void)dealloc
{
    self.portrait = nil;
    self.name = nil;
    self.position = nil;
    self.allInfo = nil;
    self.desc = nil;
    [super dealloc];
}

@end

@implementation MyPersonalCell
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
//    [_favorButton release];
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
    _backgroundImageView.image = [UIImage imageNamed:@"bg_soul.png"];
    // _backgroundImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_backgroundImageView];
    
    //portrait Image
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(118 , 109, 85, 85)];
    _portraitImageView.layer.cornerRadius = 42.5;
    _portraitImageView.clipsToBounds = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_portraitImageView];
    
    UIImageView * bg_portrait = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_bg_photo.png"]] autorelease];
    bg_portrait.frame = CGRectMake(109, 100, 102, 102);
    [self.contentView addSubview:bg_portrait];
    //use bezier path instead of maskToBounds on image.layer
    //    UIBezierPath *bi = [UIBezierPath bezierPathWithRoundedRect:_portraitImageView.bounds
    //                                             byRoundingCorners:UIRectCornerAllCorners
    //                                                   cornerRadii:CGSizeMake(42.5,42.5)];
    //    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //    maskLayer.frame = _portraitImageView.bounds;
    //    maskLayer.path = bi.CGPath;
    //    _portraitImageView.layer.mask = maskLayer;
    
}
-(void)addUserPhotoLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 212, 320, 18)];
    _nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
    _nameLabel.shadowColor = [UIColor blackColor];
    _nameLabel.shadowOffset = (CGSize){0, 1};
    _nameLabel.textAlignment = UITextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_nameLabel];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 236, 320, 12)];
    _descLabel.font = [UIFont  fontWithName:@"STHeitiTC-Medium" size:12];
    _descLabel.textAlignment = UITextAlignmentCenter;
    _descLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.shadowColor = [UIColor blackColor];
    _descLabel.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:_descLabel];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton setImage:[UIImage imageNamed:@"user_settings_normal.png"] forState:UIControlStateNormal];
    [_followButton setImage:[UIImage imageNamed:@"user_settings_press.png"] forState:UIControlStateHighlighted];
    [_followButton addTarget:self action:@selector(settingButton:) forControlEvents:UIControlEventTouchUpInside];
    _followButton.frame = CGRectMake(117, 268, 90, 25);
    _followButton.backgroundColor = [UIColor clearColor];
    _followButton.titleLabel.textColor = [UIColor clearColor];
    [self.contentView addSubview:_followButton];
    
    CGRect frame = CGRectMake(_backgroundImageView.frame.size.width - 36, _backgroundImageView.frame.size.height - 36 - 113, 26, 26);
    RefreshButton * refreshButton = [[[RefreshButton alloc] initWithFrame:frame] autorelease];
    
    [self.contentView addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(refreshButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:refreshButton];
    
}
-(void)addMenuView
{
    
    UIImageView* bg_menu = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_menu.png"]] autorelease];
    bg_menu.frame = CGRectMake(0, 367, 320, 60);
    bg_menu.userInteractionEnabled = YES;
    [self.contentView addSubview:bg_menu];
    
    
    _albumButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    _albumButton.nameLabel.text = @"相册";
    _albumButton.delegate = self;
    [bg_menu addSubview:_albumButton];
    
//    _favorButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(80, 0, 80, 60)];
//    _favorButton.nameLabel.text = @"喜欢";
//    _favorButton.delegate = self;
//    [bg_menu addSubview:_favorButton];
    
    _followingButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(160, 0, 80, 60)];
    _followingButton.nameLabel.text = @"跟随";
    _followingButton.delegate = self;
    [bg_menu addSubview:_followingButton];
    
    _followedButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(240, 0, 80, 60)];
    _followedButton.nameLabel.text = @"跟随者";
    _followedButton.delegate = self;
    [bg_menu addSubview:_followedButton];
    
}
- (void)updataData
{
    if (self.datasource == nil )         return;
    [_portraitImageView setImageWithURL:[NSURL URLWithString:_dataSource.portrait] placeholderImage:[UIImage imageNamed:@"user_bg_photo_defout.png"]];
    if (_dataSource.name ||[_dataSource.name isKindOfClass:[NSNull class]] || [_dataSource.name isEqualToString:@""]) {
        _nameLabel.text = @"起个名字吧";
    }else{
        _nameLabel.text = [_dataSource name];
    }
    if (!_dataSource.desc ||[_dataSource.desc isKindOfClass:[NSNull class]] || [_dataSource.desc isEqualToString:@""]) {
        _descLabel.text = @"赶快装扮下吧";
    }else{
        _descLabel.text = self.datasource.desc;
    }
    
    _albumButton.numlabel.text = [NSString stringWithFormat:@"%d", self.datasource.albumAmount];
//    _favorButton.numlabel.text = [NSString stringWithFormat:@"%d",self.datasource.favouriteAmount];
    _followingButton.numlabel.text = [NSString stringWithFormat:@"%d", self.datasource.followingAmount];
    _followedButton.numlabel.text  = [NSString stringWithFormat:@"%d", self.datasource.followedAmount];
}

-(void)setDatasource:(MyPersonalCelldataSource *)datasource
{
    if (_dataSource != datasource) {
        [_dataSource release];
        _dataSource = [datasource retain];
    }
    [self updataData];
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
-(void)settingButton:(UIButton*)button
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:settingClick:)]) {
        [_delegate MyPersonalCell:self settingClick:button];
    }
}
- (void)refreshButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:refreshClick:)]) {
        [_delegate MyPersonalCell:self refreshClick:button];
    }
}
#pragma makr -
#pragma mark ButtonClick-Method
-(void)photoBookClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:photoBookClicked:)]) {
        [_delegate MyPersonalCell:self photoBookClicked:sender];
    }
}
- (void)favoriteButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:favoriteClicked:)]) {
        [_delegate MyPersonalCell:self favoriteClicked:sender];
    }
}
- (void)followingButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:followingButtonClicked: )]) {
        [_delegate MyPersonalCell:self followingButtonClicked:sender];
    }
}

- (void)followedButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(MyPersonalCell:followedButtonClicked:)]) {
        [_delegate MyPersonalCell:self followedButtonClicked:sender];
    }
}

@end
