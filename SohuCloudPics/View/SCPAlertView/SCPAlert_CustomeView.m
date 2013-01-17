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
        
        self.tag = TIPVIEWTAG;
        CGRect rect = [[UIScreen mainScreen] bounds];
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
        _alertboxImageView.image = [UIImage imageNamed:@"popup_alert.png"];
        _alertboxImageView.center = CGPointMake(rect.size.width / 2.f, rect.size.height / 2.f);
        [self addSubview:_alertboxImageView];
        
        _title  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 40)];
        _title.textAlignment = UITextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = [UIColor whiteColor];
        _title.text = title;
        [_alertboxImageView addSubview:_title];
        
    }
    return self;
}

- (void)show
{
    UIWindow * win = [[UIApplication sharedApplication].delegate window];
    NSLog(@"%@",[win subviews]);
    for (UIView * view in [win subviews]) {
        if ([view isKindOfClass:[SCPAlert_CustomeView class]] ) {
            return;
        }
    }
    [win addSubview:self];
    [SCPGuideViewExchange exchageViewForwindow];
    [self performSelector:@selector(dismiss)withObject:nil afterDelay:1.5f];
}
- (void)dismiss
{
    [self removeFromSuperview];
}
@end
