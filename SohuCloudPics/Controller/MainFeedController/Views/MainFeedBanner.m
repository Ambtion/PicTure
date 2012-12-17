//
//  SCPMainFeedBanner.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainFeedBanner.h"


@implementation MainFeedBannerDataSource

@synthesize photoCountLabel = _photoCountLabel;
@synthesize timeLabel = _timeLabel;

- (void)dealloc
{
    self.photoCountLabel = nil;
    self.timeLabel = nil;
    [super dealloc];
}
@end

@implementation MainFeedBanner

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews
{
    _nameLabel = [[UIImageView alloc] init];
    _nameLabel.frame = CGRectMake(130, 0, 60, 24);
    _nameLabel.image = [UIImage imageNamed:@"title_feed.png"];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    
    _photoCountLabel = [[UILabel alloc] init] ;
    _photoCountLabel.frame = CGRectMake(5, 38, 160, 18);
    _photoCountLabel.font = [UIFont systemFontOfSize:12];
    _photoCountLabel.textAlignment = UITextAlignmentLeft;
    _photoCountLabel.backgroundColor = [UIColor clearColor];
    _photoCountLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_photoCountLabel];
    
    _timeLabel = [[UILabel alloc] init] ;
    _timeLabel.frame = CGRectMake(160, 38, 155, 18);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = UITextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_timeLabel];
    
    CGRect frame = self.frame;
    frame.size.height = 100;
    self.frame = frame;
    
}
#pragma mark - 
#pragma mark updata
-(MainFeedBannerDataSource*)dataSource
{
    return _dataSource;
}
-(void)setDataSource:(MainFeedBannerDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataData];
    }
}
- (void)updataData
{
    _photoCountLabel.text = _dataSource.photoCountLabel;
    _timeLabel.text = _dataSource.timeLabel;
}


@end
