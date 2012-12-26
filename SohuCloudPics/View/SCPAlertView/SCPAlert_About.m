//
//  SCPAlert_About.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import "SCPAlert_About.h"

@implementation SCPAlert_About
- (void)dealloc
{
    [_backgroundImageView release];
    [_alertboxImageView release];
    [_okButton release];
    [_descLabel release];
    [super dealloc];
}
- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        
        self.frame = [[UIScreen mainScreen] bounds];
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (_backgroundImageView.bounds.size.height - 295) / 2, 240, 295)];
        _alertboxImageView.image = [UIImage imageNamed:@"pop_up_L.png"];
        [_alertboxImageView setUserInteractionEnabled:YES];
        [self addSubview:_alertboxImageView];
        
        _okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _okButton.frame = CGRectMake((_alertboxImageView.frame.size.width -  _alertboxImageView.frame.size.width + 60)/2.f, 95 + 90 + 30 + 15 + 10, _alertboxImageView.frame.size.width - 60, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(aboutOkClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
        
    }
    return self;
}
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}
- (void)aboutOkClicked:(UIButton*)button
{
    [self removeFromSuperview];
}
@end
