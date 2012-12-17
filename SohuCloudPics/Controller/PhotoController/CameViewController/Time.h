//
//  Time.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Time : UIView
{
    UIImageView * _g_image;
    UIImageView * _s_image;
    NSInteger  _number;
}
- (id)initWithFrame:(CGRect)frame;
-(void)timerZreo;
-(void)updateTime;
@end
