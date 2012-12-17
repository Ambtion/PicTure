//
//  FeedCell.m
//  sohu_yuntu
//
//  Created by Sheng Zhong on 12-8-17.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "FeedCell.h"

#import "PersonalPageViewController.h"



static NSString *translateTime(NSDate *time)
{
    // TODO
    return @"2小时之前";
}




@implementation FeedCellTailer

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

@synthesize portraitView = _portraitView;
@synthesize nameLabel = _nameLabel;
@synthesize positionTimeLabel = _positionTimeLabel;
@synthesize favorButton = _favorButton;
@synthesize commentButton = _commentButton;

- (void)dealloc
{
    [_dataSource release];
    [_delegate release];
    
    [_portraitView release];
    [_nameLabel release];
    [_positionTimeLabel release];
    [_favorButton release];
    [_commentButton release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.portraitView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)] autorelease];
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 30)] autorelease];
        self.positionTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 35, 150, 20)] autorelease];
        self.favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.nameLabel.font = [UIFont systemFontOfSize:24];
        self.positionTimeLabel.font = [UIFont systemFontOfSize:12];
        self.favorButton.frame = CGRectMake(200, 5, 50, 20);
        self.favorButton.backgroundColor = [UIColor grayColor];
        self.commentButton.frame = CGRectMake(260, 5, 50, 20);
        self.commentButton.backgroundColor = [UIColor grayColor];
        
        self.portraitView.userInteractionEnabled = YES;
        [self.portraitView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)] autorelease]];
        
        [self addSubview:self.portraitView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.positionTimeLabel];
        [self addSubview:self.favorButton];
        [self addSubview:self.commentButton];
    }
    return self;
}

- (void)setDataSource:(NSObject <FeedCellDataSource> *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
    }
    
    self.portraitView.image = dataSource.portrait;
    self.nameLabel.text = dataSource.name;
    self.positionTimeLabel.text = [NSString stringWithFormat:@"%@, %@", dataSource.position, translateTime(dataSource.time)];
    [self.favorButton setTitle:[NSString stringWithFormat:@"%d", dataSource.favorAmount] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d", dataSource.commentAmount] forState:UIControlStateNormal];
}

- (void)clicked
{
    [self.delegate feedCellTailer:self clickedAt:1];
}

@end






@implementation FeedCell

@synthesize dataSource = _dataSource;

@synthesize photoImageView = _feedImageView;
@synthesize tailer = _tailer;

- (void)dealloc
{
    [_dataSource release];
    
    [_feedImageView release];
    [_tailer release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        self.tailer = [[[FeedCellTailer alloc] initWithFrame:CGRectMake(0, 100, 320, 70)] autorelease];
        
        [self addSubview:self.photoImageView];
        [self addSubview:self.tailer];
    }
    return self;
}

- (void)setDataSource:(NSObject <FeedCellDataSource> *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
    }
    
    self.photoImageView.image = dataSource.photo;
    self.tailer.dataSource = dataSource;
}

@end
