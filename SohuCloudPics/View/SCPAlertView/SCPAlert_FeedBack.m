//
//  SCPAlert_FeedBack.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import "SCPAlert_FeedBack.h"

@implementation SCPAlert_FeedBack
- (void)dealloc
{
    [_backgroundImageView release];
    [_okButton release];
    [_alertboxImageView release];
    [_cancelbutton  release];
    [super dealloc];
}
- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        self.frame = [[UIScreen mainScreen] bounds];
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (_backgroundImageView.bounds.size.height - 295) / 2, 240, 295)];
        _alertboxImageView.image = [UIImage imageNamed:@"info_pop_feedback_bg.png"];
        [_alertboxImageView setUserInteractionEnabled:YES];
        [self addSubview:_alertboxImageView];
        
        _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _okButton.frame = CGRectMake(22, 240, 89, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"发送" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(feedBackClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
     
        _cancelbutton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _cancelbutton.frame = CGRectMake(129,240, 89, 35);
        _cancelbutton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelbutton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_cancelbutton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L.png"] forState:UIControlStateNormal];
        [_cancelbutton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L_press.png"] forState:UIControlStateHighlighted];
        [_cancelbutton addTarget:self action:@selector(feedBackClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_cancelbutton];
    }
    return self;
}
- (void)feedBackClick:(UIButton *)button
{
    [self removeFromSuperview];

}
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

@end
