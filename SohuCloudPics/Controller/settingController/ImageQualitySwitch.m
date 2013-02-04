//
//  ImageQualitySwitch.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-29.
//
//

#import "ImageQualitySwitch.h"
#import "SCPLoginPridictive.h"
#import "SCPPerfrenceStoreManager.h"

static BOOL store = YES;

@implementation ImageQualitySwitch
@synthesize originalImage;
- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 91.f;
    frame.size.height = 27.f;
    if (self = [super initWithFrame:frame]) {
        store = YES;
        originalImage = YES;
        [self setSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithOriginalImage:(BOOL)isPublic
{
    store = NO;
    self.originalImage = isPublic;
    frame.size.width = 91.f;
    frame.size.height = 27.f;
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews
{
    
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    UISwipeGestureRecognizer * gesutre = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)] autorelease];
    gesutre.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_button addGestureRecognizer:gesutre];
    UITapGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)] autorelease];
    [self addGestureRecognizer:tap];
    [self addSubview:_button];
    
    if (store) {
        self.image = [UIImage imageNamed:@"switch_btn.png"];
        NSNumber * isuplaodJPEG = [SCPPerfrenceStoreManager isUploadJPEGImage];
        if (!isuplaodJPEG ||![isuplaodJPEG boolValue]) {
            originalImage = 1;
            _button.frame = (CGRect) {0, 0, 51, 27};
        }else{
            originalImage = 0;
            _button.frame = (CGRect) {40,0, 51, 27};
        }
        
    }else{
        self.image = [UIImage imageNamed:@"alubm_switch_btn.png"];
        if (self.originalImage) {
            _button.frame = (CGRect) {0, 0, 51, 27};
        }else{
            _button.frame = (CGRect) {40,0, 51, 27};
        }
    }
    [self setbuttinImage];
}
-(void)setbuttinImage
{
    if (originalImage) {
        
        if (store) {
            [_button setBackgroundImage:[UIImage imageNamed:@"real_size_btn.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"real_size_btn.png"] forState:UIControlStateHighlighted];
            [self isUploadJPEGImage:NO];
        }else{
            [_button setBackgroundImage:[UIImage imageNamed:@"personal_album_btn.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"personal_album_btn.png"] forState:UIControlStateHighlighted];
        }
    }else {
        if (store) {
            [_button setBackgroundImage:[UIImage imageNamed:@"resize_btn.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"resize_btn.png"] forState:UIControlStateHighlighted];
            [self isUploadJPEGImage:YES];
        }else{
            [_button setBackgroundImage:[UIImage imageNamed:@"social_album_btn.png"] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@"social_album_btn.png"] forState:UIControlStateHighlighted];
        }
    }
}
- (void)isUploadJPEGImage:(BOOL)ture
{
    [SCPPerfrenceStoreManager setIsUploadJPEGImage:ture];
}
-(void)buttonDrag:(UISwipeGestureRecognizer *)gesture
{
    originalImage = !originalImage;
    UIViewAnimationOptions  options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.2 delay:0 options:options animations:^{
        if (!originalImage) {
            _button.frame = CGRectMake(40, 0, 51, 27);
        }else {
            _button.frame = CGRectMake(0, 0, 51, 27);
        }
    } completion:^(BOOL finished) {
        [self setbuttinImage];
    }];
}

@end
