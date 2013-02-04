//
//  PlazeDataAdapter.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-29.
//
//

#import <Foundation/Foundation.h>

#define MAXFRAMECOUNTLIMIT 4

@interface PlazeDataAdapter : NSObject

//获取随机的图片视图
+ (NSDictionary *)getViewFrameForRandom;
//从info中获取frames对应的URL
+ (NSArray *)getURLArrayByImageFrames:(NSArray *)frames FrominfoSource:(NSArray *)infoSource;
//获取frames对应的viewframe
+ (NSArray *)getBorderViewOfImageViewByImageViewFrame:(NSArray *) viewFrame;
@end
