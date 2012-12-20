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
#import "CameraImageHelper.h"

@implementation CameraImageHelper
@synthesize session,captureOutput,image,g_orientation,movieFileOutPut;
@synthesize preview;

static CameraImageHelper *sharedInstance = nil;


- (void) initialize
{
    //1.创建会话层
    self.session = [[[AVCaptureSession alloc] init] autorelease];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *error;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [self.session addInput:captureInput];
    [self initconfigurationInput];
    //配置输出
    //3.1 图片输出
    imagecaptureOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [imagecaptureOutput setOutputSettings:outputSettings];
    [outputSettings release];
    [self.session addOutput:imagecaptureOutput];
    
    //3.2 视频输出
    movieFileOutPut = [[[AVCaptureMovieFileOutput alloc] init] autorelease];
    if ([self.session canAddOutput:movieFileOutPut]) {
        [self.session addOutput:movieFileOutPut];
    }else {
        NSLog(@"cannot AddOutput movieFileOutPut");
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
        NSLog(@"imageCaptureconnection nil");
    }
    [imageCaptureconnection setEnabled:YES];
    if (imageCaptureconnection.isVideoOrientationSupported)
        imageCaptureconnection.videoOrientation = UIInterfaceOrientationPortrait;

    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (movieConnection == nil) {
        NSLog(@"movieConnection is nil");
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

-(void) embedPreviewInView: (UIView *) aView {
    if (!session) return;
    preview = [AVCaptureVideoPreviewLayer layerWithSession: session];
//    preview.orientation = UIInterfaceOrientationPortrait;
    preview.frame = aView.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill; 
    [aView.layer addSublayer: preview];
}

- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        g_orientation = UIImageOrientationUp;
        preview.orientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        g_orientation = UIImageOrientationDown;
        preview.orientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    [CATransaction commit];
}
#pragma mark -
#pragma mark captureImage
-(void)Captureimage
{
    //get UIImage
    
    [imagecaptureOutput captureStillImageAsynchronouslyFromConnection:imageCaptureconnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
//         CFDictionaryRef exifAttachments =
//         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//         if (exifAttachments) {
//             // Do something with the attachments.
//         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [[UIImage alloc] initWithData:imageData]  ;   
         self.image = [[[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:UIImageOrientationRight] autorelease];
         [t_image release],t_image = nil;
     }];
    
}
-(void)CaptureStillImageWithblockSucecces:(void(^)(UIImage* image))sucecces;
{
    //get UIImage
    if ([imagecaptureOutput isCapturingStillImage] || !imageCaptureconnection.isEnabled) {
        UIAlertView * alt = [[[UIAlertView alloc] initWithTitle:@"imageConnection" message:@"DisEnable" delegate:session cancelButtonTitle:@"cancel" otherButtonTitles: nil] autorelease];
        [alt show];
        return;
    }else {
        NSLog(@"Image::%@",imageCaptureconnection);
        [imagecaptureOutput captureStillImageAsynchronouslyFromConnection:imageCaptureconnection completionHandler:
         ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                 UIImage *t_image = [[UIImage alloc] initWithData:imageData]  ;   
                 self.image = [[[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:UIImageOrientationRight] autorelease];
                [t_image release],t_image = nil;
                //t_image is  same  to self.image
                 dispatch_async(dispatch_get_main_queue(), ^{
                     sucecces(self.image);
                     self.image = nil;
                 });

            [pool drain];
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
            CGFloat x = point.x / 480;
            CGFloat y = point.y /  320;
            [currentDevice setFocusPointOfInterest:CGPointMake(x, y)];
            [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
    [currentDevice unlockForConfiguration];
    }
}
-(void)switchCameraPosition
{
    NSLog(@"switchCameraPosition start %@",imageCaptureconnection);
    [session beginConfiguration];
    // Remove an existing capture device.
    // Add a new capture device.
    // Reset the preset.
    NSArray* devices = [AVCaptureDevice devices];
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
    [session removeInput:input];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:willaddDevic error:nil];
    [session addInput:captureInput];
    [session commitConfiguration];
    
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    [self initconfigurationInput];

//  [self ConfigurationOutput];
    NSLog(@"switchCameraPosition end %@",imageCaptureconnection);
    
}
#pragma chang outPut
-(void)changeOutPutToimage
{
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    movieConnection.enabled = NO;
    imageCaptureconnection.enabled = YES;
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    NSLog(@"movieConnection %d,imageCaptureconnection: %d",movieConnection.isEnabled,imageCaptureconnection.isEnabled);

}
-(void)changeOutPutToMoveFile
{
    imageCaptureconnection = [imagecaptureOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection = [movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    session.sessionPreset = AVCaptureSessionPresetMedium;
    movieConnection.enabled = YES;
    imageCaptureconnection.enabled = NO;
    NSLog(@"movieConnection %d,imageCaptureconnection: %d",movieConnection.isEnabled,imageCaptureconnection.isEnabled);
}
#pragma mark - 
#pragma mark recording
-(void)recordingAtPath:(NSString *)path
{
    NSURL * outUrl = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    
    if ([movieFileOutPut isRecording] || !movieConnection.isEnabled) {
        UIAlertView * alt = [[[UIAlertView alloc] initWithTitle:@"movieConnection" message:@"DisEnable" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil] autorelease];
        [alt show];
        return;
    }else {
		//Start recording
        [movieFileOutPut startRecordingToOutputFileURL:outUrl  recordingDelegate:self];
    } 
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
        NSLog(@"didFinishRecordingToOutputFileAtURL %@",error);
    }
    NSLog(@"record ok");
}
-(void)stopRecoding
{
    if ([movieFileOutPut isRecording] == NO) {
        return;
    }
    [movieFileOutPut stopRecording];
}

- (void) dealloc
{
	self.image = nil;
	[super dealloc];
}

#pragma mark Class Interface

+ (id) sharedInstance // private
{
	if(!sharedInstance) sharedInstance = [[self alloc] init];
    return sharedInstance;
}

+ (void) startRunning
{
	[[[self sharedInstance] session] startRunning];	
}

+ (void) stopRunning
{
	[[[self sharedInstance] session] stopRunning];
}

+ (UIImage *) image
{
	return [[self sharedInstance] image];
}

+(void)CaptureStillImage
{
    [[self sharedInstance] Captureimage];
}
+(void)CaptureStillImageWithblockSucecces:(void(^)(UIImage* image))sucecces
{
    [[self sharedInstance] CaptureStillImageWithblockSucecces:sucecces];
}
+ (void)embedPreviewInView: (UIView *) aView
{
    [[self sharedInstance] embedPreviewInView:aView];
}
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[self sharedInstance] changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation];
}
+(void)switchCameraPosition
{
    [[self sharedInstance] switchCameraPosition];
}
+(void)setFlashMode:(AVCaptureFlashMode)mode
{
    [[self sharedInstance] setFlashMode:mode];
}
+(void)focusAtpoint:(CGPoint)point
{
    [[self sharedInstance] focusAtpoint:point];
}

+(void)changeOutPutToimage
{
    [[self sharedInstance] changeOutPutToimage];
}
+(void)changeOutPutToMoveFile
{
    [[self sharedInstance] changeOutPutToMoveFile];
}
+(void)recordingAtPath:(NSString*)path
{
    [[self sharedInstance] recordingAtPath:path];
}
+(void)stopRecoding
{
    [[[self sharedInstance] movieFileOutPut] stopRecording];
}

@end
