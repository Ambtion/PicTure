//
//  CameraView.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
//#import "CameraImageHelper.h"

#import "SCPMenuNavigationController.h"

#import "ImageEdtingController.h"
#import "GiFViewController.h"
#import "AlbumControllerManager.h"

#import "SCPUploadController.h"

#define CAPTURENUM 60

@implementation CameraViewController
@synthesize preview = _preview;
@synthesize imageForTemp = _imageForTemp;
@synthesize imageGenerator = _imageGenerator;

-(id)init
{
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataContainers];
    //    self.view.frame = CGRectMake(0, 0, 320, 480);
    self.view.backgroundColor = [UIColor blackColor];
    //addpreview
    [self addPreviews];
    //reload gesture
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backClick:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.preview addGestureRecognizer:right];
    [right release];
    
    //camera initalize
    [self initializeCamera];
    //add FunctionButton
    [self addFuctionsubviews];
    //_focusView
    _focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _focusView.backgroundColor = [UIColor clearColor];
    _focusView.image = [UIImage imageNamed:@"focus.png"];
    //preview picture
    if (_tampview == nil){
        _tampview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _tampview.image = [UIImage imageNamed:@"short_bg.png"];
        _tampview.backgroundColor = [UIColor blackColor];
        _tampview.userInteractionEnabled = NO;
    }
    
    [self.preview  addSubview:_tampview];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc {
    
    NSLog(@"%s",__FUNCTION__);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_tampview release];
    [_preview release];
    [_focusView release];
    [_flashButton release];
    [_secenSwitch release];
    [_backButton release];
    [_photoSwitch release];
    [_photoBook release];
    [_imageGenerator release];
    [_gifArray release];
    [camerBox release];
    //teamp
    self.imageForTemp = nil;
    [super dealloc];
}
#pragma customize NavigationBar
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    [((SCPMenuNavigationController *)self.navigationController).menuView setHidden:YES];
    [((SCPMenuNavigationController *)self.navigationController).ribbonView setHidden:YES];
    self.navigationItem.hidesBackButton = YES;
    //为了防止viwedidiAppear中出现的未知错误;
    //    [self performSelector:@selector(openCamera) withObject:nil afterDelay:0.5];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self openCamera];
    NSLog(@"%s",__FUNCTION__);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [((SCPMenuNavigationController *)self.navigationController).ribbonView setHidden:NO];
}
#pragma mark -
-(void)initDataContainers
{
    _gifArray = [[NSMutableArray alloc] initWithCapacity:0];
    durationSeconds = 0.f;
    isBack = NO;
    isForwardImage = NO;
    isForwardGif = NO;
    isForwardPhoto = NO;
    outPutImage = YES;
}
-(void)initializeCamera
{
    NSLog(@"initializeCamera start");
    if (!camerBox)
        camerBox = [[CameraImageBox alloc] init];
    [camerBox embedPreviewInView:self.preview];

//    [CameraImageHelper initialize];
//    [CameraImageHelper embedPreviewInView:self.preview];
    [self photoSwitch:nil setPhotoTypeOfImage:outPutImage];
    
    NSLog(@"initializeCamera end");
    
}
-(void)addPreviews
{
    
    self.preview = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    [self.preview setUserInteractionEnabled:YES];
    [self.view addSubview:_preview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlFocus:)];
    tap.numberOfTapsRequired = 1;
    self.preview.userInteractionEnabled = YES;
    [self.preview addGestureRecognizer:tap];
    [tap release];
    
}
-(void)addFuctionsubviews
{
    //add Flash on preview
    _flashButton = [[FlashButton alloc] initWithOrinal:CGPointMake(10, 12)];
    [_flashButton addtarget:self action:@selector(flashswitch:)];
    
    [self.preview addSubview:_flashButton.view];
    
    //add secenSwitch preview
    _secenSwitch = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _secenSwitch.frame = CGRectMake(240, 10, 70, 40);
    [_secenSwitch addTarget:self action:@selector(secenSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_secenSwitch setImage:[UIImage imageNamed:@"摄像头.png"] forState:UIControlStateNormal];
    [_secenSwitch setImage:[UIImage imageNamed:@"摄像头-2.png"] forState:UIControlStateHighlighted];
    [self.preview addSubview:_secenSwitch];
    
    //add TabbarBg selfView
    
    //
    _tabBarView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)] autorelease];
    _tabBarView.image = [UIImage imageNamed:@"camera_bar.png"];
    [_tabBarView setUserInteractionEnabled:YES];
    _tabBarView.userInteractionEnabled = YES;
    
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 431, 320, 300)] autorelease];
    view.backgroundColor = [UIColor blackColor];
    [view addSubview:_tabBarView];
    [self.view addSubview:view];
    
    //add BackButton tabBarView
    _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _backButton.frame = CGRectMake(10, 4, 41, 41);
    [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"camera_back_btn_normal.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"camera_back_btn_press.png"] forState:UIControlStateHighlighted];
    [_tabBarView addSubview:_backButton];
    
    //add switch tabBarView
    _photoSwitch = [[PhotoSwitch alloc] initWithFrame:CGRectMake(0, 5, 120, 41) delegate:self];
    _photoSwitch.center = CGPointMake(160, 25.5);
    [_tabBarView addSubview:_photoSwitch];
    
    //去点相机进入照片接口
    //    //add photoBook tabBarView
    //    _photoBook = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    //    _photoBook.frame = CGRectMake(247, 0, 73, 49);
    //    [_photoBook addTarget:self action:@selector(photoBookClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [_photoBook setImage:[UIImage imageNamed:@"album_btn.png"] forState:UIControlStateNormal];
    //    [_photoBook setImage:[UIImage imageNamed:@"album_btn_press.png"] forState:UIControlStateHighlighted];
    //    [_tabBarView addSubview:_photoBook];
    
}

#pragma mark-
#pragma mark Camera
-(void)openCamera
{
    NSLog(@"opneCamera");
    [self.view setUserInteractionEnabled:YES];
    NSLog(@"%s start",__FUNCTION__);
//    [CameraImageHelper startRunning];
    [camerBox startRunning];
    NSLog(@"%s start 2",__FUNCTION__);
    CATransition * transiton = [CATransition animation];
    transiton.fillMode = kCAFillModeForwards;
    transiton.duration = 0.5;
    transiton.speed = 1.0;
    transiton.type = @"cameraIrisHollowOpen";
    NSLog(@"%s start end",__FUNCTION__);
    transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_tampview.layer addAnimation:transiton forKey:@"Open"];
    _tampview.alpha = 0;
}
-(void)closeCamera
{
    [self.view setUserInteractionEnabled:NO];
//    [CameraImageHelper stopRunning];
    [camerBox stopRunning];
    CATransition * transiton = [CATransition animation];
    transiton.fillMode = kCAFillModeBoth;
    transiton.duration = 0.5;
    transiton.speed = 1.0;
    transiton.delegate = self;
    transiton.type = @"cameraIrisHollowClose";
    transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_tampview.layer addAnimation:transiton forKey:@"close"];
    _tampview.alpha = 1;
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_tampview.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"animationDidStop is %d",isForwardImage);
    if (isBack) {
        isBack = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (isForwardImage){
        isForwardImage = NO;
        ImageEdtingController * imageEdting = [[[ImageEdtingController alloc] initWithUIImage:self.imageForTemp controller:self] autorelease];
        UINavigationController * nav = [[[UINavigationController alloc]initWithRootViewController:imageEdting] autorelease];
        self.imageForTemp  = nil;
        [self presentModalViewController:nav animated:YES];
        
    }else if (isForwardGif){
        isForwardGif  = NO;
        GiFViewController * gif_c = [[[GiFViewController alloc] initWithImages:[[_gifArray copy] autorelease] andDurationTimer:durationSeconds :self] autorelease];
        [_gifArray removeAllObjects];
        
        UINavigationController * nav = [[[UINavigationController alloc]initWithRootViewController:gif_c] autorelease];
        [self presentModalViewController:nav animated:YES];
        
    }else{
        [self openCamera];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        [self openCamera];
        return;
    }
    isForwardPhoto =  NO;
    AlbumControllerManager * manager = [[AlbumControllerManager alloc] initWithpresentController:self];
    [self presentModalViewController:manager animated:YES];
    [manager release];
    
}
#pragma mark -
#pragma mark Camera Fucntion
-(void)resetFlashButton
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:1];
    [UIView setAnimationDuration:0.3];
    if (outPutImage) {
        _flashButton.view.alpha = 1;
    }else {
        _flashButton.view.alpha = 0;
    }
    [UIView commitAnimations];
    
}
-(void)flashswitch:(FlashButton*)button
{
//    [CameraImageHelper setFlashMode:button.selection];
    [camerBox setFlashMode:button.selection];
}
-(void)secenSwitch:(UIButton*)button
{
    NSLog(@"secenSwitch");
    // [self closeCamera];
    [self photoSwitch:nil setPhotoTypeOfImage:outPutImage];
//    [CameraImageHelper switchCameraPosition];
    [camerBox switchCameraPosition];

    
}
-(void)backClick:(UIButton*)button
{
    NSLog(@"backClick");
    isBack = YES;
    [self closeCamera];
}
-(void)photoBookClick:(UIButton*)button
{
    NSLog(@"photoBookClick");
    isForwardPhoto = YES;
    [self closeCamera];
}
#pragma mark Focus
-(void)handlFocus:(UITapGestureRecognizer *)gesture
{
    NSLog(@"handlFocus");
    CGPoint point = [gesture locationInView:self.preview];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_focusView.superview == nil) {
            _focusView.center = point;
            [self.view addSubview:_focusView];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            _focusView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [UIView commitAnimations];
            [self performSelector:@selector(resignFocusView) withObject:nil afterDelay:1.f];
        }
//        [CameraImageHelper focusAtpoint:point];
        [camerBox focusAtpoint:point];
    }
}
-(void)resignFocusView
{
    if (_focusView.superview) {
        _focusView.transform = CGAffineTransformIdentity;
        [_focusView removeFromSuperview];
    }
}
#pragma mark -
#pragma mark photoSwitch-Method
-(void)photoSwitch:(PhotoSwitch *)swith setPhotoTypeOfImage:(BOOL)isImage
{
    [self closeCamera];
    outPutImage = isImage;
    [self resetFlashButton];
    if (isImage) {
//        [CameraImageHelper changeOutPutToimage];
        [camerBox changeOutPutToimage];
        [_flashButton.view setUserInteractionEnabled:YES];
        NSLog(@"changeOutPutToimage");
    }else {
        NSLog(@"changeOutPutToMoveFile");
//        [CameraImageHelper changeOutPutToMoveFile];
        [camerBox changeOutPutToMoveFile];
        [_flashButton.view setUserInteractionEnabled:NO];
    }
}
#pragma mark Record Capture

-(void)photoSwitch:(PhotoSwitch *)swith photoButtonClick:(UIButton *)button
{
    if (!button.userInteractionEnabled) {
        return;
    }
    if (outPutImage) {
        [self takePicture];
    }else {
//        if ([[[CameraImageHelper sharedInstance] movieFileOutPut] isRecording]) {
        if ([[camerBox movieFileOutPut] isRecording]) {
            [self stopRecordVideo];
        }else {
            [self startRecordVideo];
        }
    }
}
-(void)playMovie
{
    NSLog(@"playMovie start");
    NSString * outputPath = [[[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"output.mov"] autorelease];
    NSURL * url = [NSURL fileURLWithPath:outputPath];
    
    MPMoviePlayerViewController * pm = [[[MPMoviePlayerViewController alloc] initWithContentURL:url] autorelease];
    
    [self presentMoviePlayerViewControllerAnimated:pm];
    NSLog(@"playMovie end");
    
}
-(void)takePicture
{
//    [CameraImageHelper CaptureStillImageWithblockSucecces:^(UIImage *image) {
    [camerBox CaptureStillImageWithblockSucecces:^(UIImage *image) {
        NSLog(@"CaptureStillImageWithblockSucecces");
        self.imageForTemp = image;
        isForwardImage = YES;
        [self closeCamera];
    }];
}
-(void)startRecordVideo
{
    [self.view setUserInteractionEnabled:NO];
//    [CameraImageHelper startRunning];
    [camerBox startRunning];
    
    [self updateTimeLabel];
    _timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES] retain];
    //    [self performSelector:@selector(stopRecord_over) withObject:nil afterDelay:16.2];
    [_photoSwitch.button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_normal_2.png"] forState:UIControlStateNormal];
    [_photoSwitch.button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_press_2.png"] forState:UIControlStateHighlighted];
    
//    [CameraImageHelper recordingAtPath:[self getMoviePath]];
    [camerBox recordingAtPath:[self getMoviePath]];

//    if ([[[CameraImageHelper sharedInstance] movieFileOutPut] isRecording]) {
    if ([[camerBox  movieFileOutPut] isRecording]) {
        NSLog(@"CameraImageHelper isRecording ");
        [self.view setUserInteractionEnabled:YES];
        
    }
    
}
-(void)stopRecordVideo
{
    if ([_timer isValid])
        [_timer invalidate];
    [_timer release];
//    [CameraImageHelper stopRecoding];
//    [CameraImageHelper stopRunning];
    [camerBox stopRecoding];
    [camerBox stopRunning];
    
    [_photoSwitch.button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_normal.png"] forState:UIControlStateNormal];
    [_photoSwitch.button setBackgroundImage:[UIImage imageNamed:@"btn_camera_video_press.png"] forState:UIControlStateHighlighted];
    //    [self playMovie];
    
    [self generatSequenceofImage];
    //    [_timeLabel timerZreo];
    
}
-(void)updateTimeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[Time alloc] initWithFrame:CGRectMake(230, 380, 80, 40)];
        [self.view addSubview:_timeLabel];
    }
    [_timeLabel updateTime];
}
-(void)stopRecord_over
{
//    if ([[[CameraImageHelper sharedInstance] movieFileOutPut] isRecording]) {
        if ([[camerBox  movieFileOutPut] isRecording]) {

        [self stopRecordVideo];
    }
}
-(NSString*)getMoviePath
{
    NSLog(@"getMovie Path start");
    NSString * outputPath = [[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"output.mov"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            //Error - handle if requried
            NSLog(@"removeItemAtPath %@",error);
        }else{
            NSLog(@"removeItemAtPath ");
        }
    }
    NSLog(@"getMovie Path end");
    
    return [outputPath autorelease];
}

#pragma mark -
#pragma mark Generating image
-(void)generatSequenceofImage
{
    
    NSString * outputPath = [[[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"output.mov"] autorelease];
    AVURLAsset * myAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:outputPath] options:nil];
    [self creatimageGenerator:myAsset];
    durationSeconds = CMTimeGetSeconds([myAsset duration]);
    NSMutableArray * times = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i <= durationSeconds * 5; i++) {
        CMTime third = CMTimeMakeWithSeconds(durationSeconds * i / (durationSeconds * 5), 10);
        [times addObject:[NSValue valueWithCMTime:third]];
    }
    [times addObject:[NSValue valueWithCMTime:[myAsset duration]]];
    
    [_gifArray removeAllObjects];
    [self showActivityIndicator];
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,AVAssetImageGeneratorResult result, NSError *error) {
        @autoreleasepool {
            
            if (result == AVAssetImageGeneratorSucceeded) {
                
                [_gifArray addObject:[UIImage imageByResize:image]];
                if (! CMTimeCompare([myAsset duration], requestedTime)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self closesActivityIndicator];
                        [_timeLabel timerZreo];
                        [_timeLabel removeFromSuperview];
                        [_timeLabel release],_timeLabel = nil;
                        isForwardGif = YES;
                        self.imageGenerator = nil;
                        [myAsset release];
                        [self closeCamera];
                    });
                }
            }
            if (result == AVAssetImageGeneratorFailed) {
                NSLog(@"Failed with error: %@", [error localizedDescription]);
            }
            if (result == AVAssetImageGeneratorCancelled) {
                NSLog(@"Canceled");
            }

        }
               
    }];
}
-(void)creatimageGenerator:(AVURLAsset*)myAsset
{
    self.imageGenerator = [[[AVAssetImageGenerator alloc] initWithAsset:myAsset] autorelease];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    self.imageGenerator.maximumSize = CGSizeMake(256, 500);
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
}

-(void)showActivityIndicator
{
    
    [self.view setUserInteractionEnabled:NO];
    _alview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _alview.center = CGPointMake(160, 200);
    [self.view addSubview:_alview];
    [_alview startAnimating];
}
-(void)closesActivityIndicator
{
    [_alview stopAnimating];
    [_alview removeFromSuperview];
    [_alview release];
    [self.view setUserInteractionEnabled:YES];
}

@end
