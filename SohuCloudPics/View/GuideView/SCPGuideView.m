//
//  GuideView.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-19.
//
//
#import "SCPAppDelegate.h"
#import "SCPGuideView.h"
#import "SCPGuideViewExchange.h"

@implementation SCPGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addCustomGestureRecognizer];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.tag  = GUIDEVIEWTAG;
        [self addCustomGestureRecognizer];
    }
    return self;    
}
- (void)addCustomGestureRecognizer
{
    UIGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGustre:)] autorelease];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    [self setUserInteractionEnabled:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView * view = [gestureRecognizer view];
    CGPoint point = [gestureRecognizer locationInView:view];
    CGRect rect = CGRectMake(0, 0, 100, 100);
    return CGRectContainsPoint(rect, point);
}
- (void)show
{
    SCPAppDelegate * delegte = (SCPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIView transitionWithView:delegte.window duration:0.5 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [delegte.window addSubview:self];
        [SCPGuideViewExchange exchageViewForwindow];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)handleGustre:(UITapGestureRecognizer *)gesture
{
    if (self.superview) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"GuideViewShowed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SCPAppDelegate * delegte = (SCPAppDelegate *)[[UIApplication sharedApplication] delegate];
        [UIView transitionWithView:delegte.window duration:0.5 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self removeFromSuperview];
        } completion:^(BOOL finished) {
            
        }];
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
