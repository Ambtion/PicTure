//
//  FeedDescribtion.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "FeedDescription.h"

#define FONT [UIFont systemFontOfSize:13]
#define LINEBREAKMODE UILineBreakModeWordWrap
static NSString * EDITIMAGE[2] = {@"",@"description_icon.png"};

@implementation FeedDescriptionSource
@synthesize describtion = _describtion;
@synthesize isMe = _isMe;
-(id)init
{
    self = [super init];
    if (self)
        self.isMe = NO;
    return self;
}
- (void)dealloc
{
    self.describtion = nil;
    [super dealloc];
}
- (CGFloat)getHeigth
{
    CGSize size = CGSizeZero;
    if (self.isMe) {
        size = [self.describtion sizeWithFont:FONT constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:LINEBREAKMODE];
    }else{
        size = [self.describtion sizeWithFont:FONT constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:LINEBREAKMODE];
    }
    CGFloat heigth = MAX((size.height  + 10), 30);
    return heigth;
}
@end

@implementation FeedDescription

@synthesize penbButton = _penButton;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_describLabel release];
    [_editButton release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _editButton.backgroundColor = [UIColor clearColor];
        [_editButton setImage:[UIImage imageNamed:@"description_icon_press.png"] forState:UIControlStateHighlighted];
        [_editButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setUserInteractionEnabled:NO];
        [self.contentView addSubview:_editButton];
        _describLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 270, 15)];
        _describLabel.textAlignment = UITextAlignmentLeft;
        _describLabel.font = FONT;
        _describLabel.lineBreakMode = LINEBREAKMODE;
        _describLabel.numberOfLines = 0;
        _describLabel.textColor = [UIColor colorWithRed:138/255.f green:157/255.f blue:181/255.f alpha:1];
        _describLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_describLabel];
        
    }
    return self;
}
- (void)handleClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(feedDescription:DesEditClick:)])
        [_delegate performSelector:@selector(feedDescription:DesEditClick:) withObject:self withObject:button];
}
-(void)setDataScoure:(FeedDescriptionSource *)dataScoure
{
    
    if (_dataSource != dataScoure) {
        [_dataSource release];
        _dataSource = [dataScoure retain];
        [self updataSource];
    }
}
-(void)updataSource
{
    self.contentView.frame = CGRectMake(0, 0, 320, [_dataSource getHeigth]);
    if (!_dataSource.describtion ||![_dataSource.describtion isKindOfClass:[NSString class]]||[_dataSource.describtion isEqualToString:@""]) {
        _describLabel.text = @"暂无描述";
    }else{
        _describLabel.text = _dataSource.describtion;
    }
    
    if (_dataSource.isMe) {
        CGSize size = [_describLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
        _describLabel.frame = CGRectMake(30, 11, size.width, size.height);
        [_editButton setHidden:NO];
        [_editButton setImage:[UIImage imageNamed:EDITIMAGE[1]] forState:UIControlStateNormal];
        [_editButton setUserInteractionEnabled:_dataSource.isMe];
    }else{
        [_editButton setHidden:YES];
        CGSize size = [_describLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
        _describLabel.frame = CGRectMake(10, 11, size.width, size.height);
    }
}
- (FeedDescriptionSource*)dataScoure
{
    return _dataSource;
}
@end
