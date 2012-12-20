//
//  PhotoSwitch.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoSwitch.h"

@implementation PhotoSwitch
@synthesize delegate = _delegate;
@synthesize button = _button;
- (id)initWithFrame:(CGRect)frame delegate:(id<phothswitchDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        sectionOfImage = YES;
        [self drawRect:self.bounds];
    }
    return self;
}
- (void)dealloc
{
    [_button release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    self.image = [UIImage imageNamed:@"btn_camera_shoot_bg.png"];
    _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
  //  button.frame = (CGRect) {0,1,rect.size.width / 2.f,rect.size.height-2};
    _button.frame = (CGRect) {0,0,68,41};
    
    UISwipeGestureRecognizer * gesutre = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)] autorelease];
    gesutre.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_button addGestureRecognizer:gesutre];
    [_button addTarget:self action:@selector(buttonDrag:) forControlEvents:UIControlEventTouchDragExit];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    [self setbuttinImage];

    NSLog(@"%@",self.subviews);
}
-(void)setbuttinImage
{
    if (sectionOfImage) {
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_normal.png"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_press.png"] forState:UIControlStateHighlighted];
    }else {
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_normal.png"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_press.png"] forState:UIControlStateHighlighted];
    }
}
-(void)buttonDrag:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"buttonDrag");

    sectionOfImage = !sectionOfImage;
    [self setbuttinImage];
    [_button setUserInteractionEnabled:NO];
    UIViewAnimationOptions  options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
    [UIView animateWithDuration:0.4 delay:0 options:options animations:^{
        if (!sectionOfImage) {
            _button.frame = CGRectMake(53, 0, 68, 41);
        }else {
            _button.frame = CGRectMake(0, 0, 68, 41);
        }
    } completion:^(BOOL finished) {
        
        [_button setUserInteractionEnabled:YES];
        if ([_delegate respondsToSelector:@selector(photoSwitch:setPhotoTypeOfImage:)]) {
            [_delegate photoSwitch:self setPhotoTypeOfImage:sectionOfImage];
        }
    }];
}
-(void)buttonClick:(UIButton*)Abutton
{
    NSLog(@"buttonClick");
    if ([_delegate respondsToSelector:@selector(photoSwitch:photoButtonClick:)]) {
        [_delegate photoSwitch:self photoButtonClick:Abutton];
    }
}
@end
