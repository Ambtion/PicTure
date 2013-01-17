//
//  SCPGuideViewExchange.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-17.
//
//

#import "SCPGuideViewExchange.h"

@implementation SCPGuideViewExchange
+(void)exchageViewForwindow
{
    UIWindow * win = [[UIApplication sharedApplication].delegate window];
    
    UIView * function = [[[win viewWithTag:FUNCTINVIEWTAG] retain] autorelease];
    UIView * guideView = [[[win viewWithTag:GUIDEVIEWTAG] retain] autorelease];
    UIView * tipView = [[[win viewWithTag:TIPVIEWTAG] retain] autorelease];
    
    [function removeFromSuperview];
    [guideView removeFromSuperview];
    [tipView removeFromSuperview];
    
    [win addSubview:tipView];
    [win addSubview:guideView];
    [win addSubview:function];
}
@end
