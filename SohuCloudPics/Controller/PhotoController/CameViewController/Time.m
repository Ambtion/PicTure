//
//  Time.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Time.h"

@implementation Time
- (void)dealloc
{
    _number = 0;
    [_g_image release];
    [_s_image release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _number = 0;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 80, 40);
        
        UIImageView* bgimage = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        bgimage.image = [UIImage imageNamed:@"number_bg.png"];
        [self addSubview:bgimage];
        UIImageView * image1 = [[[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 12, 18)] autorelease];
        image1.image = [UIImage imageNamed:@"0.png"];
        [bgimage addSubview:image1];
        UIImageView * image2 = [[[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 12, 18)] autorelease];
        image2.image = [UIImage imageNamed:@"0.png"];
        [bgimage addSubview:image2];
        
        UIImageView * image3 = [[[UIImageView alloc] initWithFrame:CGRectMake(37, 10, 6, 18)] autorelease];
        image3.image = [UIImage imageNamed:@";.png"];
        [bgimage addSubview:image3];
        
        _s_image = [[UIImageView alloc] initWithFrame:CGRectMake(43, 10, 12, 18)];
        _g_image = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 12, 18)];
        _s_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",0]];
        _g_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",0]];
        [bgimage addSubview:_s_image];
        [bgimage addSubview:_g_image];
        
    }
    return self;
}
-(void)updateTime
{
    if (_number > 15) {
        return;
    }
    NSInteger _s = _number / 10;
    NSInteger _g = _number % 10;
    _s_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",_s]];
    _g_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",_g]];
    _number++;
}
-(void)timerZreo
{
    _number = 0;
    _s_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",0]];
    _g_image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",0]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
