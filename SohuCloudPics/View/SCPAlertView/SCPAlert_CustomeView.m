//
//  SCPAlert_CustomeView.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import "SCPAlert_CustomeView.h"

@implementation SCPAlert_CustomeView
- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        
//        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
//        [self addSubview:backgroundImageView];
        CGRect rect = [[UIScreen mainScreen] bounds];
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
        _alertboxImageView.image = [UIImage imageNamed:@"popup_alert.png"];
        _alertboxImageView.center = CGPointMake(rect.size.width / 2.f, rect.size.height / 2.f);
        [self addSubview:_alertboxImageView];
        
        _title  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 40)];
        _title.textAlignment = UITextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:16];
//        _title.textColor = [UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1];
        _title.textColor = [UIColor whiteColor];
        _title.text = title;
        [_alertboxImageView addSubview:_title];
    }
    return self;
}
- (void)show
{
    UIWindow * win = [[UIApplication sharedApplication].delegate window];
    for (UIView * view in [win subviews]) {
        if ([view isKindOfClass:[SCPAlert_CustomeView class]]) {
            return;
        }
    }
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [self performSelector:@selector(dismiss)withObject:nil afterDelay:2.f];
}
- (void)dismiss
{
    [self removeFromSuperview];
}
@end
