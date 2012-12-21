//
//  UIImage+ExternScale.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+ExternScale.h"

@implementation UIImage (GifTool)

+(UIImage*)imageByResize:(CGImageRef )image
{
    UIImage * sourceImage = [UIImage imageWithCGImage:image];
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(256, 256));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,0.f,-35.f);
    [sourceImage drawInRect:CGRectMake(0, 0, 256, 341)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+(NSArray *)imageByScalingProportionallyToSize:(NSArray*)sourceArray :(CGSize)targetSize
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i  = 0; i < sourceArray.count; i++) {
        UIImage *sourceImage = [sourceArray objectAtIndex:i];
        UIImage *newImage = nil;
        
        
        UIGraphicsBeginImageContext(targetSize);
        [sourceImage drawInRect:(CGRect){0,0,targetSize}];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(newImage == nil) NSLog(@"could not scale image");
        [array addObject:newImage];
    }
    return array;
}
+(NSArray *)imageByRotate:(NSArray*)imageArray:(NSInteger)interger
{
    UIImage * outputImage = nil;
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < imageArray.count; i++) {
        CGFloat rotationAngle = interger * M_PI / 2;
        //get image    
        UIImage * image = [imageArray objectAtIndex:0];
        CGRect finalRect = (CGRect) {0,0,image.size};
        //创建一个方形的画布
        UIGraphicsBeginImageContext(finalRect.size);//根据size大小创建一个基于位图的图形上下文 
        CGContextRef myContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境 
        //旋转角度
        CGContextRotateCTM(myContext, rotationAngle);
        //设置坐标,是视图显示
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        if (interger == 1) {
            y = 0 - image.size.height;
        }
        if (interger == 2) {
            x = 0 - image.size.width;
            y = 0 - image.size.height;
        }
        if (interger == 3) {
            NSLog(@"getTranslate");
            x = 0 - image.size.width;
            NSLog(@"%f",x);
        }
        
        CGSize size = CGSizeMake(x, y);
        CGContextTranslateCTM(myContext, size.width, size.height);
        if(interger == 2 || interger == 0) {
            [image drawInRect:finalRect];
            
        }else {
            NSLog(@"rotatedImage draw");
            [image drawInRect:(CGRect){0,0,{finalRect.size.height,finalRect.size.width}} ];
        }
        CGContextClipToRect(myContext, finalRect);
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [array addObject:outputImage];
    }
    return array;
    
}

@end
