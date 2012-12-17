//
//  RootViewController.h
//  pictureProcess
//
//  Created by Ibokan on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Filterlibrary.h"

@interface ImageUtil : NSObject 

+(UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;
+(UIImage*)imageWithImage:(UIImage*)inImage withMatrixNum:(NSInteger) num;
+(UIImage *)imageWithFilterImage:(UIImage*)inimage; 
+(UIImage*) image:(UIImage*) source stackBlur:(NSUInteger)inradius;//1-20;
@end
