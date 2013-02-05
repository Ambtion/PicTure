//
//  UIImage+ExternScale.h
//  SohuCloudPics
//
//  Created by sohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface UIImage (GifTool)

+(NSArray *)imageByScalingProportionallyToSize:(NSArray*)source :(CGSize)targetSize;
+(NSArray *)imageByRotate:(NSArray *)imageArray rotation:(NSInteger)interger;
+(UIImage *)imageByResize:(CGImageRef )image;

@end
