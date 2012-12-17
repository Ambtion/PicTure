//
//  MenuButtonView.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuButtonView.h"
@class MenuButtonView;
@interface MenuButtonView()
-(void)buttonClick:(UITapGestureRecognizer *)getrure;
@end

@implementation MenuButtonView
@synthesize nameLabel = _nameLabel;
@synthesize numlabel = _numlabel;
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.numlabel = nil;
    self.nameLabel = nil;
    [_gesture release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews
{
    self.numlabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 13, self.frame.size.width, 15)] autorelease];
    self.numlabel.textAlignment = UITextAlignmentCenter;
    self.numlabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    self.numlabel.backgroundColor = [UIColor clearColor];
    self.numlabel.textColor = [UIColor colorWithRed:128.f/255 green:128.f/255 blue:128.f/255 alpha:1];
    [self addSubview:self.numlabel];
    
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 12)] autorelease];
    self.nameLabel.textAlignment = UITextAlignmentCenter;
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    [self addSubview:self.nameLabel];
    
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
    [self addGestureRecognizer:_gesture];
}
-(void)buttonClick:(UITapGestureRecognizer *)gestrure
{
    if ([_delegate respondsToSelector:@selector(menu:ButtonClick:)]) {
        [_delegate menu:self ButtonClick:gestrure];
    }
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
