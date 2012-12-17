//
//  LoginTipView.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginTipView.h"

@implementation LoginTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];       
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
-(void)addSubviews
{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    image.image = [UIImage imageNamed:@"feed_no_login.png"];
    image.userInteractionEnabled = YES;
    [self addSubview:image];
    [image release];
    
    _Loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _Loginbutton.frame = CGRectMake(105, 398, 110, 35);
    [_Loginbutton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal.png"] forState:UIControlStateNormal];
    [_Loginbutton setBackgroundImage:[UIImage imageNamed:@"login_btn_press.png"] forState:UIControlStateHighlighted];
    [_Loginbutton setTitle:@"登录" forState:UIControlStateNormal];
    [_Loginbutton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    _Loginbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:_Loginbutton];
}
-(void)addtarget:(id)target action:(SEL)action
{
    [_Loginbutton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
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
