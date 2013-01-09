//
//  ImageQualitySwitch.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-29.
//
//

#import "ImageQualitySwitch.h"

@implementation ImageQualitySwitch
- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 91.f;
    frame.size.height = 27.f;
    if (self = [super initWithFrame:frame]) {
        originalImage = YES;
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews
{
    
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    self.image = [UIImage imageNamed:@"switch_btn.png"];
    _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    UISwipeGestureRecognizer * gesutre = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)] autorelease];
    gesutre.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_button addGestureRecognizer:gesutre];
    [self addSubview:_button];
    id imageInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPEG"];
    if (!imageInfo ||[imageInfo boolValue]) {
        originalImage = 0;
        _button.frame = (CGRect) {40,0, 51, 27};
    }else{
        originalImage = 1;
        _button.frame = (CGRect) {0, 0, 51, 27};
    }
    [self setbuttinImage];
}
-(void)setbuttinImage
{
    if (originalImage) {
        [_button setBackgroundImage:[UIImage imageNamed:@"real_size_btn.png"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"real_size_btn.png"] forState:UIControlStateHighlighted];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"JPEG"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        [_button setBackgroundImage:[UIImage imageNamed:@"resize_btn.png"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"resize_btn.png"] forState:UIControlStateHighlighted];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"JPEG"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"after : store %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"JPEG"]);
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
