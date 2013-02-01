//
//  PhotoSwitch.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoSwitch.h"
static BOOL isIphone5 = NO;
@implementation PhotoSwitch
@synthesize delegate = _delegate;
@synthesize button = _button;
- (id)initWithFrame:(CGRect)frame delegate:(id<phothswitchDelegate>)delegate
{
    frame.size.width = 120;
    frame.size.height = 41;
    isIphone5 = NO;
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        sectionOfImage = YES;
        [self drawRect:self.bounds];
    }
    return self;
}
- (id)initWithFrameForIphone5:(CGRect)frame delegate:(id<phothswitchDelegate>)delegate
{
    frame.size.width = 119;
    frame.size.height = 59;
    isIphone5 = YES;
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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    if (isIphone5) {
        _button.frame = (CGRect) {0,0,58,59};
        self.image = [UIImage imageNamed:@"btn_camera_shoot_bg_ios6.png"];
    }else{
        _button.frame = (CGRect) {0,0,68,41};
        self.image = [UIImage imageNamed:@"btn_camera_shoot_bg.png"];
    }
    UISwipeGestureRecognizer * gesutre = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)] autorelease];
    gesutre.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_button addGestureRecognizer:gesutre];
    [_button addTarget:self action:@selector(buttonDrag:) forControlEvents:UIControlEventTouchDragExit];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    [self setbuttinImage];
}
-(void)setbuttinImage
{
    if (sectionOfImage) {
        if (isIphone5) {
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_normal_ios6.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_press_ios6.png"] forState:UIControlStateHighlighted];
        }else{
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_normal.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_shoot_press.png"] forState:UIControlStateHighlighted];
        }
    }else {
        if (isIphone5) {
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_normal_ios6.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_press_ios6.png"] forState:UIControlStateHighlighted];
        }else{
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_normal.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_press.png"] forState:UIControlStateHighlighted];
        }
    }
}
-(void)buttonDrag:(UISwipeGestureRecognizer *)gesture
{

    sectionOfImage = !sectionOfImage;
    [self setbuttinImage];
    [_button setUserInteractionEnabled:NO];
    UIViewAnimationOptions  options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
    [UIView animateWithDuration:0.4 delay:0 options:options animations:^{
        if (!sectionOfImage) {
            if (isIphone5) {
                _button.frame = CGRectMake(61, 0, 58, 59);
            }else{
                _button.frame = CGRectMake(53, 0, 68, 41);
            }
        }else {
            if (isIphone5) {
                _button.frame = CGRectMake(0, 0, 58, 59);
            }else{
                _button.frame = CGRectMake(0, 0, 68, 41);
            }
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
    if ([_delegate respondsToSelector:@selector(photoSwitch:photoButtonClick:)]) {
        [_delegate photoSwitch:self photoButtonClick:Abutton];
    }
}
@end
