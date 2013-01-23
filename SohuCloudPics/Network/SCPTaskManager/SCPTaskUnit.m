//
//  SCPTaskUnit.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-11.
//
//

#import "SCPTaskUnit.h"
#import "SCPLoginPridictive.h"

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
//    NSLog(@"imageOrientation::%d",self.imageOrientation);
    // No-op if the orientation is already correct
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            //            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            //            transform = CGAffineTransformRotate(transform, - M_PI_2);/*还原*/
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, - M_PI_2);
            
            //            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            //            transform = CGAffineTransformRotate(transform, M_PI_2);/*还原*/
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            //            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

@implementation SCPTaskUnit


@synthesize asseetUrl = _asseetUrl;
@synthesize description = _description;
@synthesize taskState = _taskState;
@synthesize thumbnail = _thumbnail;
@synthesize request = _request;
@synthesize data = _data;

- (void)dealloc
{
    self.asseetUrl = nil;
    self.thumbnail = nil;
    self.description = nil;
    self.request = nil;
    self.data = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.taskState = UPLoadstatusWait;
    }
    return self;
}
- (NSURL *)asseetUrl
{
    //    NSLog(@"%s : AssetURL is Write property",__FUNCTION__);
    return nil;
}

- (void)getImageSucess:(void (^)(NSData * imageData,SCPTaskUnit * unit))resultBlock failture:(void(^)(NSError * error,SCPTaskUnit * unit))myfailtureBlock;
{
    
    if (self.data) {
        resultBlock(self.data,self);
        return;
    }
    ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:_asseetUrl resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation * defaultRep = [asset defaultRepresentation];
        UIImage * image = [UIImage imageWithCGImage:[defaultRep fullResolutionImage]
                                              scale:[defaultRep scale] orientation:(UIImageOrientation)[defaultRep orientation]];
        image = [image fixOrientation];
        NSNumber * num = nil;
        if ([SCPLoginPridictive currentUserId]){
            NSDictionary * userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:[SCPLoginPridictive currentUserId]];
            num = [userinfo objectForKey:@"JPEG"];
        }else{
            resultBlock(nil,self);
            return;
        }
        NSData * data = nil;
        if (!num || ![num boolValue]) {
//            NSLog(@"%s JPEG",__FUNCTION__ );
            //PNG
            data = UIImageJPEGRepresentation(image, 1.f);
        }else{
            //JPEG
            data = UIImageJPEGRepresentation(image, 0.7f);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data,self);
            [lib release];
        });
    } failureBlock:^(NSError *error) {
        myfailtureBlock(error,self);
        [lib release];
    }];
}
@end
