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
@synthesize bookMark = _bookMark;
- (void)dealloc
{
    self.describtion = nil;
    self.bookMark = nil;
    [super dealloc];
}
@end

@implementation FeedDescription

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
        
//        UIImageView* bookmarkview = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 15, 15)] autorelease];
//        bookmarkview.image = [UIImage imageNamed:@"tag_icon.png"];
//        [self addSubview:bookmarkview];
//        bookMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, 270, 15)];
//        bookMarkLabel.textAlignment = UITextAlignmentLeft;
//        bookMarkLabel.font = [UIFont systemFontOfSize:13];
//        bookMarkLabel.textColor = [UIColor colorWithRed:138/255.f green:157/255.f blue:181/255.f alpha:1];
//        bookMarkLabel.backgroundColor = [UIColor clearColor];
//        bookMarkLabel.text = @"书签 旅游 生活 自拍";
//        [self addSubview:bookMarkLabel];
//        UIImageView * endView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"end_bg.png"]] autorelease];
//        endView.tag = 100;
//        endView.frame = CGRectMake((320 - 30)/2.f, describLabel.frame.size.height + describLabel.frame.origin.y + 10, 30, 30);
//        [self.contentView addSubview:endView];
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
  
//    UIImageView * view = ( UIImageView *)[self.contentView viewWithTag:100];
//    view.frame = CGRectMake((320 - 30)/2.f, describLabel.frame.size.height + describLabel.frame.origin.y + 10, 30, 30);
//    NSLog(@"self frame::%@, labelFrame:%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(describLabel.frame));
}
-(FeedDescriptionSource*)dataScoure
{
    return _dataSource;
}
@end
