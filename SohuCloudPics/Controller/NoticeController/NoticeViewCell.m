//
//  NoticeViewCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "NoticeViewCell.h"

@implementation NoticeDataSource
@synthesize name = _name;
@synthesize upTime = _upTime;
@synthesize photoUrl = _photoUrl;
@synthesize content = _content;
- (void)dealloc
{
    self.name = nil;
    self.content = nil;
    self.photoUrl = nil;
    self.upTime = nil;
    [super dealloc];
}

@end
@implementation NoticeViewCell

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
    [_timeLabel release];
    [super dealloc];
}

- (void)addSubviews
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
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 16, 28 + 86, 28)];
    _timeLabel.textAlignment = UITextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:98.f/255 green:98.f/255 blue:98.f/255 alpha:1];
    [self.contentView addSubview:_timeLabel];
    
    UIImageView * lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    lineView.frame = CGRectMake(0, 59, 320, 1);
    [self.contentView addSubview:lineView];
    [lineView release];

}
-(void)updataData
{
    
    NSString * photo_url =[NSString stringWithFormat:@"%@_c70",_dataSource.photoUrl];
    [_imageCoverView setImageWithURL:[NSURL URLWithString:photo_url] placeholderImage:[UIImage imageNamed:@"portrait_default.png"] options:0];
    _titleLabel.text = _dataSource.name;
    _descLabel.text = _dataSource.content;
    _timeLabel.text = _dataSource.upTime;
}

- (NoticeDataSource *)dataSource
{
    return _dataSource;
}
- (void)setDataSource:(NoticeDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataData];
    }
}
-(void)follweImageCick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(NoticeViewCell:portraitClick:)]) {
        [_delegate NoticeViewCell:self portraitClick:sender];
    }
}
@end
