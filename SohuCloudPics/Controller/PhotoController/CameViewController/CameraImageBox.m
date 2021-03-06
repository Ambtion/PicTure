//
//  CameraImageBox.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-21.
//
//
//
//  CameraImageHelper.m
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

//#import <CoreVideo/CoreVideo.h>
//#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import "CameraImageBox.h"

@implementation CameraImageBox

@synthesize session,captureOutput,image,g_orientation,movieFileOutPut;
@synthesize preview;

- (void) dealloc
{
    
	self.image = nil;
    self.session = nil;
    [imagecaptureOutput release];
    [movieFileOutPut release];
	[super dealloc];
}
- (void) initialize
{
    //1.创建会话层
    self.session = [[[AVCaptureSession alloc] init] autorelease];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    }else{
        return;
    }
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *error = nil;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
//		NSLog(@"Error: %@", error);
		return;
	}
    
    [self.session addInput:captureInput];
    [self initconfigurationInput];
    
    //配置输出
    //3.1 图片输出
    imagecaptureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [imagecaptureOutput setOutputSettings:outputSettings];
    [outputSettings release];
    [self.session addOutput:imagecaptureOutput];
    
    //3.2 视频输出
    movieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:movieFileOutPut]) {
        [self.session addOutput:movieFileOutPut];
    }else {
//        NSLog(@"cannot AddOutput movieFileOutPut");
    }
    
    [self ConfigurationOutput];

}
-(void)initconfigurationInput
{
    AVCaptureDeviceInput * inPut = [[self.session inputs] objectAtIndex:0];
    AVCaptureDevice * currentDevice = inPut.device;
    NSError* error = nil;
    BOOL lockAcquired = [currentDevice lockForConfiguration:&error];
    if (lockAcquired) {
        if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        if ([currentDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [currentDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        if ([currentDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [currentDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [currentDevice unlockForConfiguration];
    }
}
-(void)ConfigurationOutput
{
    //3.3 连接
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    if (imageCaptureconnection == nil) {
//        NSLog(@"imageCaptureconnection nil");
    }
    [imageCaptureconnection setEnabled:YES];
    if (imageCaptureconnection.isVideoOrientationSupported)
        imageCaptureconnection.videoOrientation = UIInterfaceOrientationPortrait;
    
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (movieConnection == nil) {
//        NSLog(@"movieConnection is nil");
    }
    [movieConnection setEnabled:NO];
    if (movieConnection.isVideoOrientationSupported)
        movieConnection.videoOrientation = UIInterfaceOrientationPortrait;
    movieConnection.videoMaxFrameDuration = CMTimeMake(150, 15);
    movieConnection.videoMinFrameDuration = CMTimeMake(150, 15);
    
}
- (id) init
{
	if (self = [super init]) [self initialize];
	return self;
}
- (void) startRunning
{
    [self.session startRunning];
}
- (void) stopRunning
{
    [self.session stopRunning];
}

-(void) embedPreviewInView: (UIView *) aView {
    
    if (!session) return;
    preview = [AVCaptureVideoPreviewLayer layerWithSession: session];
    preview.frame = aView.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: preview];
    
}

//- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    
//    [CATransaction begin];
//    
//    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
//    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
//    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        g_orientation = UIImageOrientationUp;
//            imageCaptureconnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//            movieConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
//        g_orientation = UIImageOrientationDown;
//            imageCaptureconnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//            movieConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//    }else{
//            imageCaptureconnection.videoOrientation = AVCaptureVideoOrientationPortrait;
//            movieConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
//    }
//    [CATransaction commit];
//}

#pragma mark -
#pragma mark captureImage
-(void)CaptureStillImageWithblockSucecces:(void(^)(UIImage* image))sucecces;
{
    //get UIImage
    if ([imagecaptureOutput isCapturingStillImage] || !imageCaptureconnection.isEnabled) {
        return;
    }else {
        [imagecaptureOutput captureStillImageAsynchronouslyFromConnection:imageCaptureconnection completionHandler:
         ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
             NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage * t_image = [[UIImage alloc] initWithData:imageData ];
             self.image = [[[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:UIImageOrientationRight] autorelease];
             [t_image release],t_image = nil;
             dispatch_async(dispatch_get_main_queue(), ^{
                 sucecces(self.image);
                 self.image = nil;
             });
             [pool release];
         }];
    }
}
#pragma  mark -
#pragma  mark Mode function
-(void)setFlashMode:(AVCaptureFlashMode)mode
{
    AVCaptureDevice* deviec = nil;
    AVCaptureDeviceInput * inPut = [[self.session inputs] objectAtIndex:0];
    deviec = inPut.device;
    NSError* error = nil;
    BOOL lockAcquired = [deviec lockForConfiguration:&error];
    if (lockAcquired) {
        if ([deviec hasFlash] && [deviec isFlashModeSupported:mode]) {
            [deviec setFlashMode:mode];
        }
        [deviec unlockForConfiguration];
    }
}
-(void)focusAtpoint:(CGPoint)point
{
    AVCaptureDeviceInput * inPut = [[self.session inputs] objectAtIndex:0];
    AVCaptureDevice * currentDevice = inPut.device;
    NSError* error = nil;
    BOOL lockAcquired = [currentDevice lockForConfiguration:&error];
    if (lockAcquired) {
        if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            CGFloat x = point.x / [[UIScreen mainScreen] bounds].size.height;
            CGFloat y = point.y /  320;
            [currentDevice setFocusPointOfInterest:CGPointMake(x, y)];
            [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [currentDevice unlockForConfiguration];
    }
}
-(void)switchCameraPosition
{
    // Remove an existing capture device.
    // Add a new capture device.
    // Reset the preset.
    
    [session beginConfiguration];
    NSArray * devices = [AVCaptureDevice devices];
    AVCaptureDevice* front = nil;
    AVCaptureDevice* back = nil;
    AVCaptureDevice* willaddDevic = nil;
    for (AVCaptureDevice * dev in devices) {
        if (dev.position == AVCaptureDevicePositionBack) {
            back = dev;
        }
        if (dev.position == AVCaptureDevicePositionFront) {
            front = dev;
        }
    }
    AVCaptureDeviceInput * input = [[session inputs] objectAtIndex:0];
    if ([input.device isEqual:back]) {
        willaddDevic = front;
    }
    if ([[input device] isEqual:front]) {
        willaddDevic = back;
    }
    if (!willaddDevic) return;
    AVCaptureDeviceInput * captureInput = [AVCaptureDeviceInput deviceInputWithDevice:willaddDevic error:nil];
    [session removeInput:input];
    [session addInput:captureInput];
    [session commitConfiguration];
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    [self initconfigurationInput];
    
}
#pragma chang outPut
-(void)changeOutPutToimage
{
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (movieConnection.isEnabled)
        movieConnection.enabled = NO;
    if (!imageCaptureconnection.isEnabled)
        imageCaptureconnection.enabled = YES;
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [self.session setSessionPreset:AVCaptureSessionPresetPhoto] ;
    }
//    NSLog(@"movieConnection %d,imageCaptureconnection: %d",movieConnection.isEnabled,imageCaptureconnection.isEnabled);
}
-(void)changeOutPutToMoveFile
{
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!movieConnection.isEnabled)
        movieConnection.enabled = YES;
    if (imageCaptureconnection.isEnabled)
        imageCaptureconnection.enabled = NO;
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    }
//    NSLog(@"movieConnection %d,imageCaptureconnection: %d",movieConnection.isEnabled,imageCaptureconnection.isEnabled);
}
#pragma mark -
#pragma mark recording
-(void)recordingAtPath:(NSString *)path
{
    NSURL * outUrl = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    if ([movieFileOutPut isRecording] || !movieConnection.isEnabled) {
        return;
    }else {
        [movieFileOutPut startRecordingToOutputFileURL:outUrl  recordingDelegate:self];
    }
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
//        NSLog(@"didFinishRecordingToOutputFileAtURL %@",error);
    }
//    NSLog(@"record ok");
}
-(void)stopRecoding
{
    if ([movieFileOutPut isRecording] == NO) {
        return;
    }
    [movieFileOutPut stopRecording];
}



@end
