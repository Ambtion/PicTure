//
//  FeedDescribtion.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "FeedDescription.h"

@implementation FeedDescriptionSource

@synthesize describtion = _describtion;
- (void)dealloc
{
    self.describtion = nil;
    [super dealloc];
}
@end

@implementation FeedDescription
- (void)dealloc
{
    [describLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView * image = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)] autorelease];
        image.image = [UIImage imageNamed:@"description_icon.png"];
        [self.contentView addSubview:image];
        describLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 270, 15)];
        describLabel.textAlignment = UITextAlignmentLeft;
        describLabel.font = [UIFont systemFontOfSize:13];
        describLabel.lineBreakMode = UILineBreakModeWordWrap;
        describLabel.numberOfLines = 0;
        describLabel.textColor = [UIColor colorWithRed:138/255.f green:157/255.f blue:181/255.f alpha:1];
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.text = @"该图片无描述";
        [self.contentView addSubview:describLabel];
        
    }
    return self;
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
    if (!_dataSource.describtion ||![_dataSource.describtion isKindOfClass:[NSString class]]||[_dataSource.describtion isEqualToString:@""]) {
        describLabel.text = @"该图片无描述";
    }else{
        
        describLabel.text = _dataSource.describtion;
        [describLabel sizeToFit];
    }
}
-(FeedDescriptionSource*)dataScoure
{
    return _dataSource;
}
@end
