//
//  SCPAlert_DetailView.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import "SCPAlert_DetailView.h"
#define OFFSETY 10
@implementation SCPAlert_DetailView

- (void)dealloc
{
    [_backgroundImageView release];
    [_alertboxImageView release];
    [_descLabel release];
    [super dealloc];
    
}

- (id)initWithMessage:(SCPAlbum *)album delegate:(id<SCPAlert_DetailViewDelegate>)delegate
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"pop_bg.png"];
        [self addSubview:_backgroundImageView];
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 202) / 2, 240, 215)];
        _alertboxImageView.image = [UIImage imageNamed:@"pop_alert_M_bg.png"];
        [self addSubview:_alertboxImageView];
        [_alertboxImageView setUserInteractionEnabled:YES];
        
        
        UILabel * titlelabel = [[[UILabel alloc] initWithFrame:CGRectMake(0 + 20, 15, _alertboxImageView.bounds.size.width - 40, 18)] autorelease];
        titlelabel.backgroundColor = [UIColor clearColor];
        titlelabel.textColor =  [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        titlelabel.textAlignment = UITextAlignmentCenter;
        titlelabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
        titlelabel.text = album.name;
        [_alertboxImageView addSubview:titlelabel];
        
        
        UIFont * font = [UIFont systemFontOfSize:15];
        UIFont * font2 = [UIFont systemFontOfSize:15];
        
        UILabel * photoNum = [[[UILabel alloc] initWithFrame:CGRectMake(20 ,50, 100, 15)] autorelease];
        photoNum.font = font;
        photoNum.backgroundColor = [UIColor clearColor];
        photoNum.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        photoNum.textAlignment = UITextAlignmentLeft;
        photoNum.text = @"图片数量";
        [_alertboxImageView addSubview:photoNum];
        
        UILabel * photoNumDe = [[[UILabel alloc] initWithFrame:CGRectMake(_alertboxImageView.frame.size.width - 120 , 50, 100, 15)] autorelease];
        photoNumDe.font = font2;
        photoNumDe.backgroundColor = [UIColor clearColor];
        photoNumDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        photoNumDe.textAlignment = UITextAlignmentRight;
        photoNumDe.text = [NSString stringWithFormat: @"共%d张图片",album.photoNum];
        [_alertboxImageView addSubview:photoNumDe];
        
        UILabel * permission = [[[UILabel alloc] initWithFrame:CGRectMake(20 , 85, 100, 15)] autorelease];
        permission.font = font;
        permission.backgroundColor = [UIColor clearColor];
        permission.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        permission.textAlignment = UITextAlignmentLeft;
        permission.text = @"专辑权限";
        [_alertboxImageView addSubview:permission];
        
        UILabel * permissionDe = [[[UILabel alloc] initWithFrame:CGRectMake(_alertboxImageView.frame.size.width - 120 , 85, 100, 15)] autorelease];
        permissionDe.font = font2;
        permissionDe.backgroundColor = [UIColor clearColor];
        permissionDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        permissionDe.textAlignment = UITextAlignmentRight;
        if (album.permission){
            permissionDe.text = @"公开专辑";
        }else{
            permissionDe.text = @"私密专辑";
        }

        [_alertboxImageView addSubview:permissionDe];
        
        
        UILabel * viewCount = [[[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 15)] autorelease];
        viewCount.font = font;
        viewCount.backgroundColor = [UIColor clearColor];
        viewCount.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        viewCount.textAlignment = UITextAlignmentLeft;
        viewCount.text = @"浏览次数";
        [_alertboxImageView addSubview:viewCount];
        
        UILabel * viewCountDe = [[[UILabel alloc] initWithFrame:CGRectMake(_alertboxImageView.frame.size.width - 120, 120, 100, 15)] autorelease];
        viewCountDe.font = font2;
        viewCountDe.backgroundColor = [UIColor clearColor];
        viewCountDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        viewCountDe.textAlignment = UITextAlignmentRight;
        viewCountDe.text = [NSString stringWithFormat:@"%d次",album.viewCount];
        [_alertboxImageView addSubview:viewCountDe];
        
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelButton.frame = CGRectMake(22, 215 - 35 - 20, 90, 35);

        _okButton.frame = CGRectMake((_alertboxImageView.frame.size.width -  _alertboxImageView.frame.size.width + 60)/2.f, 215 - 55, _alertboxImageView.frame.size.width - 60, 35);
        _okButton.titleLabel.font = [_okButton.titleLabel.font fontWithSize:16];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"pop_up_btn_L_press.png"] forState:UIControlStateHighlighted];
        [_okButton addTarget:self action:@selector(okClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_alertboxImageView addSubview:_okButton];
        _delegate = delegate;
    }
    return self;
}
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)okClicked:(UIButton*)button
{
    if ([_delegate respondsToSelector:@selector(alertView:alertViewOKClicked:)]) {
        [_delegate performSelector:@selector(alertView:alertViewOKClicked:) withObject:self withObject:button];
    }
    [self removeFromSuperview];
}

@end
