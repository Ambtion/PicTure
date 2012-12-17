//
//  CommentCell.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation CommentCellDataSource

@synthesize portraitImage = _portraitImage;
@synthesize content = _content;
@synthesize name = _name;
@synthesize time = _time;
- (void)dealloc
{
    self.portraitImage = nil;
    self.content = nil;
    self.name = nil;
    self.time = nil;
    [super dealloc];
}
@end

@implementation CommentCell

@synthesize delegate = _delegate;

- (void)dealloc
{
    [_portraitImageView release];
    [_nameLabel release];
    [_contentLabel release];
    [_timeLabel release];
    
    [_dataSource release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = self.bounds;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        
    }
    return self;
}
-(void)addSubviews
{
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    _portraitImageView.userInteractionEnabled = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
    [_portraitImageView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitViewClicked)] autorelease]];
    [self.contentView addSubview:_portraitImageView];

    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 160, 15)];
    _nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15];
    _nameLabel.textColor = [UIColor colorWithRed:97/255.f green:120/255.f blue:137/255.f alpha:1];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = UITextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 10 + 1.5, 75, 12)];
    _timeLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];

    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:_timeLabel];

    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 235, 0)];
    _contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13];
    _contentLabel.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];

    [self.contentView addSubview:_contentLabel];
    
    //for line
    UIImageView* border = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]] autorelease];
    border.frame = CGRectMake(0, self.bounds.size.height, 320, 1);
    border.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:border];

}
#pragma mark -
#pragma mark updataData
-(void)updataData
{
    _portraitImageView.image = _dataSource.portraitImage;
    _nameLabel.text = _dataSource.name;
    _timeLabel.text = _dataSource.time;
    
    NSString *cont = _dataSource.content;
    _contentLabel.text = cont;
    
    CGSize calcSize = [cont sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = _contentLabel.frame;
    frame.size.height = calcSize.height;
    _contentLabel.frame = frame;
    
    CGFloat h = calcSize.height + 45;
    frame = self.frame;
    frame.size.height = h > 70 ? h : 70;
    self.frame = frame;
}
-(void)setDataSource:(CommentCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
    }
    [self updataData];
}
-(CommentCellDataSource *)dataSource
{
    return _dataSource;
}
#pragma mark -
#pragma mark Delegate

- (void)portraitViewClicked
{
    if ([_delegate respondsToSelector:@selector(commentCell:portraitViewClickedWith:)]) {
        [_delegate commentCell:self portraitViewClickedWith:nil];
    }
}


@end
