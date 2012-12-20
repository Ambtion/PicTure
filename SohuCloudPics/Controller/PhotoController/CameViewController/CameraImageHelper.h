//
//  CameraImageHelper.h
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>
{
	AVCaptureSession *session;
    
    AVCaptureStillImageOutput *imagecaptureOutput;
    AVCaptureConnection* imageCaptureconnection;
    AVCaptureMovieFileOutput * movieFileOutPut;
    AVCaptureConnection* movieConnection;
	
    UIImage *image;
    AVCaptureVideoPreviewLayer *preview;
    UIImageOrientation g_orientation;
}
@property (retain) AVCaptureSession *session;
@property (retain) AVCaptureOutput *captureOutput;
@property (retain) UIImage *image;
@property (assign) UIImageOrientation g_orientation;
@property (assign) AVCaptureVideoPreviewLayer *preview;
@property (retain) AVCaptureFileOutput * movieFileOutPut;
+ (void) startRunning;
+ (void) stopRunning;
+ (UIImage *) image;
+ (id) sharedInstance; 
+ (void)embedPreviewInView: (UIView *) aView;

//imageOutPut
+(void)CaptureStillImage;
+(void)CaptureStillImageWithblockSucecces:(void(^)(UIImage* image))sucecces;
+(void)switchCameraPosition;
+(void)setFlashMode:(AVCaptureFlashMode)mode;
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
+(void)focusAtpoint:(CGPoint)point;
//video
+(void)changeOutPutToMoveFile;
+(void)changeOutPutToimage;
+(void)recordingAtPath:(NSString*)path;
+(void)stopRecoding;
@end
