//
//  SCPAlter_DeletView.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import "SCPAlert_DeletView.h"



@implementation SCPAlert_DeletView

- (void)dealloc
{
    [_backgroundImageView release];
    [_alertboxImageView release];
    [_descLabel release];
    
    [super dealloc];
}

- (id)initWithMessage:(NSString *)msg delegate:(id<SCPAlertDeletViewDelegate>)delegate;
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 178 + 50) / 2 , 240, 178 - 50)];
        UIImage * popImage = [UIImage imageNamed:@"pop_up_bg_delet.png"];
        _alertboxImageView.image = popImage;
        [_alertboxImageView setUserInteractionEnabled:YES];
        [self addSubview:_alertboxImageView];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 114 - 89, 180, 30)];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        _descLabel.font = [_descLabel.font fontWithSize:16];
        _descLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descLabel.numberOfLines = 0;
        _descLabel.text = msg;
        _descLabel.textAlignment = UITextAlignmentCenter;
        [_alertboxImageView addSubview:_descLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(22, 209 - 89 - 50, 90, 35);
        _cancelButton.titleLabel.font = [_cancelButton.titleLabel.font fontWithSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_cancelButton];
        
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(128, 209 - 89 - 50, 90, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_normal.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_btn_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(okClicked) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
        _delegate = delegate;
        
    }
    return self;
    
}
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)cancelClicked
{
    [self removeFromSuperview];
}

- (void)okClicked
{
    if ([_delegate respondsToSelector:@selector(alertViewOKClicked:)]) {
        [_delegate performSelector:@selector(alertViewOKClicked:) withObject:self];
    }
    [self removeFromSuperview];
}

@end
