//
//  ImageToolBox.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-24.
//
//

#import <Foundation/Foundation.h>

@interface ImageToolBox : NSObject

+(UIImage*)image:(UIImage *)source ByScaling: (CGFloat)scale;

+(UIImage*)image:(UIImage*)imageSource afterRotate:(NSInteger)rotatennum;
+(UIImage*)image:(UIImage*)image clipinRect:(CGRect)rect scale:(CGFloat)scale;
+(UIImage*)image:(UIImage *)inputimage  addRadiuOnBlurimage:(CGPoint)point scale:(CGFloat)scale;

@end
