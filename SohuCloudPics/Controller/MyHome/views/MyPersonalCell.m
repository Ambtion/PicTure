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

@synthesize isInit = _isInit;
@synthesize portrait = _portrait;
@synthesize name = _name;
@synthesize position = _position;
@synthesize desc = _desc;
@synthesize albumAmount = _albumAmount;
@synthesize followedAmount = _followedAmount;
@synthesize followingAmount = _followingAmount;

- (void)dealloc
{
    
    self.portrait = nil;
    self.name = nil;
    self.position = nil;
    self.desc = nil;
    [super dealloc];
}
- (id)init
{
    if (self = [super init]) {
        self.isInit = YES;
    }
    return self;
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
    [_settingButton release];
    [_albumButton release];
    [bgCircleView release];
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
    [self.contentView addSubview:_backgroundImageView];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBack:)] autorelease];
    [_backgroundImageView addGestureRecognizer:gesture];
    [_backgroundImageView setUserInteractionEnabled:YES];
    [self setHomeBackGroudImage];
    
    //portrait Image
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(118 , 109, 85, 85)];
    _portraitImageView.layer.cornerRadius = 42.5;
    _portraitImageView.clipsToBounds = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_portraitImageView];
    
    bgCircleView = [[UIImageView alloc] initWithFrame:CGRectMake(109, 100, 102, 102)];
    [self.contentView addSubview:bgCircleView];
}
- (void)setHomeBackGroudImage
{
    NSString * bgname = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeBackImage"];
    if (bgname) {
        _backgroundImageView.image = [UIImage imageNamed:bgname];
    }else{
        _backgroundImageView.image = [UIImage imageNamed:@"user_bg_soul.png"];
    }
}
- (void)changeBack:(UITapGestureRecognizer *)gesture
{
    HomeBackContainer * hc = [[[HomeBackContainer alloc] initWithDelegate:self] autorelease];
    [hc show];
}
- (void)homeBackContainerSeleced:(UIImage *)image
{
    NSLog(@"%s",__FUNCTION__);
    _backgroundImageView.image = image;
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
    
    _settingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_settingButton setImage:[UIImage imageNamed:@"user_settings_normal.png"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"user_settings_press.png"] forState:UIControlStateHighlighted];
    [_settingButton addTarget:self action:@selector(settingButton:) forControlEvents:UIControlEventTouchUpInside];
    _settingButton.frame = CGRectMake(117, 268, 90, 25);
    _settingButton.backgroundColor = [UIColor clearColor];
    _settingButton.titleLabel.textColor = [UIColor clearColor];
    [self.contentView addSubview:_settingButton];
    
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
    if (!_dataSource.name ||![_dataSource.name isKindOfClass:[NSString class]] || [_dataSource.name isEqualToString:@""]) {
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
    _followingButton.numlabel.text = [NSString stringWithFormat:@"%d", self.datasource.followingAmount];
    _followedButton.numlabel.text  = [NSString stringWithFormat:@"%d", self.datasource.followedAmount];
    
    if (self.datasource.isInit) {
        _portraitImageView.image = nil;
        _nameLabel.text = nil;
        _descLabel.text = nil;
        _albumButton.numlabel.text = nil;
        _followingButton.numlabel.text = nil;
        _followedButton.numlabel.text = nil;
        
    }else{
        bgCircleView.image = [UIImage imageNamed:@"user_bg_photo.png"];
    }
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
