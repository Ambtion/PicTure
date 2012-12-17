//
//  BannerForHeadView.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-17.
//
//

#import "BannerForHeadView.h"

@implementation BannerForHeadView

@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;
@synthesize bannerName = _bannerName;
@synthesize labelName = _labelName;
- (void)dealloc
{
    self.leftLabel = nil;
    self.rightLabel = nil;
    self.labelName = nil;
    [_bannerName release];
    [_labelName release];
    [super dealloc];
}

- (id)initWithImageName:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 100)];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        _bannerName.image = image;
    }
    return self;
}

- (id)initWithLabelName:(NSString *)name
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 100)];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        _labelName.text = name;
    }
    return self;
}

- (void)addSubviews
{
    _bannerName = [[UIImageView alloc] init];
    _bannerName.frame = CGRectMake(130, 0 + 44, 60, 24);
    _bannerName.backgroundColor = [UIColor clearColor];
    [self addSubview:_bannerName];
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(66, 44, 320 - 132, 24)];
    _labelName.font = [UIFont fontWithName:@"STHeitiTC-Light" size:22];
    _labelName.textColor = [UIColor colorWithRed:92.f/255.f green:92.f/255.f blue:92.f/255.f alpha:1];
    _labelName.textAlignment = UITextAlignmentCenter;
    _labelName.backgroundColor = [UIColor clearColor];
    [self addSubview:_labelName];
    
    _leftLabel = [[UILabel alloc] init] ;
    _leftLabel.frame = CGRectMake(5, 38 + 44, 160, 18);
    _leftLabel.font = [UIFont systemFontOfSize:12];
    _leftLabel.textAlignment = UITextAlignmentLeft;
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] init] ;
    _rightLabel.frame = CGRectMake(160, 38 + 44, 155, 18);
    _rightLabel.font = [UIFont systemFontOfSize:12];
    _rightLabel.textAlignment = UITextAlignmentRight;
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_rightLabel];
    [self BannerreloadDataSource];
}

- (id <BannerDataSoure>)datasouce
{
    return _datasouce;
}

- (void)setDatasouce:(id <BannerDataSoure>)datasouce
{
    _datasouce = datasouce;
    [self BannerreloadDataSource];
}

- (void)BannerreloadDataSource
{
    if ([_datasouce respondsToSelector:@selector(bannerDataSouceLeftLabel)]) {
        _leftLabel.text = [_datasouce bannerDataSouceLeftLabel];
    } else {
        _leftLabel.text = nil;
    }
    if ([_datasouce respondsToSelector:@selector(bannerDataSouceRightLabel)]) {
        _rightLabel.text = [_datasouce bannerDataSouceRightLabel];
    } else {
        _rightLabel.text = nil;
    }
}

@end
