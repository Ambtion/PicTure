//
//  ImageToolBox.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-24.
//
//

#import "ImageToolBox.h"
#import "ImageUtil.h"

CGSize CGSizeAbsolute(CGSize size) {
    return (CGSize){fabs(size.width), fabs(size.height)};
}

@implementation ImageToolBox

+(UIImage*)image:(UIImage *)source ByScaling: (CGFloat)scale
{
    UIImage *newImage = nil;
    CGSize size = CGSizeMake(source.size.width / scale,source.size.height / scale);
    
    UIGraphicsBeginImageContext(size);
    [source drawInRect:(CGRect){0,0,size}];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//clip
+(UIImage*)image:(UIImage*)imageSource clipinRect:(CGRect)rect scale:(CGFloat)scale
{
    CGRect finalrect = CGRectZero;
    finalrect =  CGRectMake(rect.origin.x * scale , rect.origin.y * scale, rect.size.width * scale, rect.size.height  * scale);
    
    CGImageRef  cgimage = CGImageCreateWithImageInRect(imageSource.CGImage, finalrect);
    UIImage* finalimage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    return finalimage;
}
//ration
+(UIImage*)image:(UIImage*)imageSource afterRotate:(NSInteger)rotatennum
{
    UIImage* outputImage = nil;
    CGFloat rotationAngle = rotatennum * M_PI / 2;
    //get finalimageRect
    CGSize rotationOriginal = CGSizeAbsolute(CGSizeApplyAffineTransform(imageSource.size, CGAffineTransformMakeRotation(rotationAngle)));
    CGRect finalRect = (CGRect) {0,0,rotationOriginal};
    //创建一个方形的画布
    UIGraphicsBeginImageContext(finalRect.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef myContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    
    //旋转角度
    CGContextRotateCTM(myContext, rotationAngle);
    //设置坐标,是视图显示
    CGSize size = [self getTranslateofImage:imageSource :rotatennum];
    CGContextTranslateCTM(myContext, size.width, size.height);
    if(abs(rotatennum) == 2 ) {
        [imageSource drawInRect:finalRect];
        
    }else {
        [imageSource drawInRect:(CGRect){0,0,{finalRect.size.height,finalRect.size.width}} ];
    }
    CGContextClipToRect(myContext, finalRect);
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
    
}
+(CGSize)getTranslateofImage:(UIImage*)imageSource :(NSInteger)rotatennum
{
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    if (rotatennum == 1 || rotatennum == -3) {
        y = 0 - imageSource.size.height;
    }
    if (abs(rotatennum) == 2) {
        x = 0 - imageSource.size.width;
        y = 0 - imageSource.size.height;
    }
    if (rotatennum == 3 || rotatennum == -1) {
        x = 0 - imageSource.size.width;
    }
    return (CGSize){x,y};
}

//blur

+(UIImage*)image:(UIImage *)imageSource  addRadiuOnBlurimage:(CGPoint)point scale:(CGFloat)scale
{
    UIImage* finalImage = nil;
    scale *= 2;
    CGFloat radius = 0;
    
    if (point.x < 120  || point.y < 120 ) {
        radius = point.x < point.y ? point.x : point.y;
    }else {
        radius = 120;
    }
    radius *= scale;
    
    finalImage = [ImageUtil image:imageSource stackBlur:7.5 * scale];
    
    UIGraphicsBeginImageContext(CGSizeMake(radius * 2, radius*2));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    CGContextAddPath(ctx, clippath);
    CGContextClip(ctx);
    
    
    CGRect rect = (CGRect){ radius - point.x * scale ,radius-point.y *scale,imageSource.size};
    [imageSource drawInRect:rect];
    
    CGContextRestoreGState(ctx);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    image = [[self maskImage:image withMask:[UIImage imageNamed:@"s.png"]] retain];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(imageSource.size);
    [finalImage drawInRect:(CGRect){0,0,imageSource.size}];
    [image drawInRect:CGRectMake(point.x * scale - radius, point.y * scale - radius, radius * 2, radius*2) blendMode:kCGBlendModeNormal alpha:1];
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [image release];
    return finalImage;
}

+(UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    CGImageRelease(mask);
    UIImage * finalimage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    return finalimage;
}
@end
