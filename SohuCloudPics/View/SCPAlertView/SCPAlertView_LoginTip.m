//
//  SCPAlertView_LoginTip.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import "SCPAlertView_LoginTip.h"
//#define LAYOUT
@implementation SCPAlertView_LoginTip

-(void)layoutSubviews
{
    NSLog(@"%s",__FUNCTION__);
    for (UIView *v in self.subviews) {
        
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImageView *imageV = (UIImageView *)v;
            UIImage *image = [UIImage imageNamed:@"pop_up_m_bg.png"];
            [imageV setImage:image];
        }
        if ([v isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)v;
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.font = [UIFont systemFontOfSize:20.f];
            label.textColor = [UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1];
            label.shadowColor = [UIColor clearColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
        }
        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIButton * button = (UIButton *)v;
            button.titleLabel.minimumFontSize = 10;
            button.titleLabel.textAlignment = UITextAlignmentCenter;
            button.backgroundColor = [UIColor clearColor];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            UIImage * image = nil;
            image = [UIImage imageNamed:@"ALertView.png"];
            image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            image = [UIImage imageNamed:@"ALertView_press.png"];
            image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
            [button setBackgroundImage:image forState:UIControlStateHighlighted];
            
            [button setTitleColor:[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1] forState:UIControlStateHighlighted];
            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        }
    }
}

@end
