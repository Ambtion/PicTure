//
//  RefreshButton.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-12.
//
//

#import "RefreshButton.h"


@implementation RefreshButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size.width = 35;
        rect.size.height = 35;
        self.frame = rect;
        [self setBackgroundImage:[UIImage imageNamed:@"header_refresh.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"header_refresh_press.png"] forState:UIControlStateHighlighted];
    }
    return self;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:self action:@selector(buttonClick:) forControlEvents:controlEvents];
    myTarget = target;
    myAction = action;
}
- (void)buttonClick:(UIButton * )button
{
    [self rotateButton];
    [myTarget performSelector:myAction];
}
- (void)rotateButton
{
    CGAffineTransform transfrom1 = CGAffineTransformRotate(self.transform,M_PI_2);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = transfrom1;
    } completion:^(BOOL finished) {
        CGAffineTransform transfrom2 = CGAffineTransformRotate(self.transform, M_PI_2);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = transfrom2;
        } completion:^(BOOL finished) {
            CGAffineTransform transfrom3 = CGAffineTransformRotate(self.transform, M_PI_2);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.transform = transfrom3;
            } completion:^(BOOL finished) {
                CGAffineTransform transfrom4 = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.transform = transfrom4;
                } completion:^(BOOL finished) {
                    
                }];
            }];

        }];
    }];
}
@end
