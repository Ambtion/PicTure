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
        
        _alertboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height - 295) / 2, 240, 295)];
        _alertboxImageView.image = [UIImage imageNamed:@"pop_up_L.png"];
        [self addSubview:_alertboxImageView];
        [_alertboxImageView setUserInteractionEnabled:YES];
        
        
        
        UILabel * titlelabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 14, _alertboxImageView.bounds.size.width, 15)] autorelease];
        titlelabel.font = [UIFont systemFontOfSize:15];
        titlelabel.backgroundColor = [UIColor clearColor];
        titlelabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        titlelabel.textAlignment = UITextAlignmentCenter;
        titlelabel.text = @"信息";
        [_alertboxImageView addSubview:titlelabel];
        
        UIFont * font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
        UILabel * nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 40, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        nameLabel.font = font;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.text = @"相册名称:";
        [_alertboxImageView addSubview:nameLabel];
        UILabel * nameDeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 55 + 4, _alertboxImageView.frame.size.width - 60, 32)] autorelease];
        nameDeLabel.font = font;
        nameDeLabel.numberOfLines = 2;
        nameDeLabel.lineBreakMode = UILineBreakModeTailTruncation;
        nameDeLabel.backgroundColor = [UIColor clearColor];
        nameDeLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        nameDeLabel.textAlignment = UITextAlignmentLeft;
        nameDeLabel.text = album.name;
        [_alertboxImageView addSubview:nameDeLabel];
        
        UILabel * photoNum = [[[UILabel alloc] initWithFrame:CGRectMake(30, 91 + OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        photoNum.font = font;
        photoNum.backgroundColor = [UIColor clearColor];
        photoNum.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        photoNum.textAlignment = UITextAlignmentLeft;
        photoNum.text = @"专辑大小:";
        [_alertboxImageView addSubview:photoNum];
        UILabel * photoNumDe = [[[UILabel alloc] initWithFrame:CGRectMake(30, 91 + 19 + OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        photoNumDe.font = font;
        photoNumDe.backgroundColor = [UIColor clearColor];
        photoNumDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        photoNumDe.textAlignment = UITextAlignmentLeft;
        photoNumDe.text = [NSString stringWithFormat: @"共%d 张图片",album.photoNum];
        [_alertboxImageView addSubview:photoNumDe];
        
        UILabel * permission = [[[UILabel alloc] initWithFrame:CGRectMake(30, 125 + 2 * OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        permission.font = font;
        permission.backgroundColor = [UIColor clearColor];
        permission.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        permission.textAlignment = UITextAlignmentLeft;
        permission.text = @"权限大小:";
        [_alertboxImageView addSubview:permission];
        UILabel * permissionDe = [[[UILabel alloc] initWithFrame:CGRectMake(30, 140 + 4 + 2 * OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        permissionDe.font = font;
        permissionDe.backgroundColor = [UIColor clearColor];
        permissionDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        permissionDe.textAlignment = UITextAlignmentLeft;
        if (album.permission){
            permissionDe.text = @"公开相册";
        }else{
            permission.text = @"私有相册";
        }
        [_alertboxImageView addSubview:permissionDe];
        
        
        UILabel * viewCount = [[[UILabel alloc] initWithFrame:CGRectMake(30, 140 + 19 + 3 * OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        viewCount.font = font;
        viewCount.backgroundColor = [UIColor clearColor];
        viewCount.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        viewCount.textAlignment = UITextAlignmentLeft;
        viewCount.text = @"访问数:";
        [_alertboxImageView addSubview:viewCount];
        UILabel * viewCountDe = [[[UILabel alloc] initWithFrame:CGRectMake(30, 178 + 3 * OFFSETY, _alertboxImageView.frame.size.width - 60, 15)] autorelease];
        viewCountDe.font = font;
        viewCountDe.backgroundColor = [UIColor clearColor];
        viewCountDe.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        viewCountDe.textAlignment = UITextAlignmentLeft;
        viewCountDe.text = [NSString stringWithFormat:@"%d人",album.viewCount];
        [_alertboxImageView addSubview:viewCountDe];
        
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake((_alertboxImageView.frame.size.width -  _alertboxImageView.frame.size.width + 60)/2.f, 95 + 90 + 30 + 15 + 10, _alertboxImageView.frame.size.width - 60, 35);
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
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(alertView:alertViewOKClicked:)]) {
        [_delegate performSelector:@selector(alertView:alertViewOKClicked:) withObject:self withObject:button];
    }
}

@end
