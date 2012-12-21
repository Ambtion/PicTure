//
//  CameraImageBox.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-21.
//
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@interface CameraImageBox : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>
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

- (void) startRunning;
- (void) stopRunning;
- (void)embedPreviewInView: (UIView *) aView;
//imageOutPut
-(void)CaptureStillImageWithblockSucecces:(void(^)(UIImage* image))sucecces;
-(void)switchCameraPosition;
-(void)setFlashMode:(AVCaptureFlashMode)mode;
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void)focusAtpoint:(CGPoint)point;
//video
-(void)changeOutPutToMoveFile;
-(void)changeOutPutToimage;
-(void)recordingAtPath:(NSString*)path;
-(void)stopRecoding;
@end
