//
//  GiFViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GiFViewController.h"
#import "ImageUtil.h"
#import "SCPMenuNavigationController.h"
#import "SCPUploadController.h"

#import "SCPAlert_WaitView.h"

@implementation GiFViewController
@synthesize imageArray = _imageArray;
- (void)dealloc
{
    NSLog(@"%s start",__FUNCTION__);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.imageArray = nil;
    [_gifResize release];
    [_gifDuration release];
    [_gifFitterBar release];

    [_imageview release];
    [_boundsView release];
    [_playButton release];
    [_activity release];
    [_waitView release];
    [_saveButton release];
    [super dealloc];
    NSLog(@"%s start end",__FUNCTION__);
 
}
#pragma mark -
#pragma mark init
-(id)initWithImages:(NSArray*) array andDurationTimer:(Float64)time :(id)controller
{
    
    if (self = [super init]) {
        _controller = controller;
        self.imageArray = array;
        _durationTime = time;
        _rotate = 0;
        isHiddenFitter = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camera_bg.png"]];
    
    //reload gesture
    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_bg.png"]] autorelease];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gifbackTop:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    [right release];
    
    [self addboundsView];
    [self addPlayButton];
    [self addViewBar];
    [self addTabBar];
    NSLog(@"self Frame:%@",NSStringFromCGRect(self.view.frame));
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma addSubViews
-(void)addboundsView
{
    _boundsView = [[UIView alloc] initWithFrame:CGRectMake(25, 65, 270, 270)];
    _boundsView.backgroundColor = [UIColor clearColor];
    [self addImageView];
    UIImageView * bgview = [[UIImageView alloc] initWithFrame:_boundsView.bounds];
    bgview.image = [UIImage imageNamed:@"Gif_bg.png"];
    [_boundsView addSubview:bgview];
    [self.view addSubview:_boundsView];
    [bgview release];
}
-(void)addImageView
{
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 256, 256)];
    _imageview.backgroundColor = [UIColor clearColor];
    _imageview.image = [self.imageArray objectAtIndex:0];
    _imageview.animationImages = self.imageArray;
    _imageview.animationRepeatCount = 1;
    _imageview.animationDuration = _durationTime;
    [_boundsView addSubview:_imageview];
}
-(void)addPlayButton
{
    _playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _playButton.frame = CGRectMake(0, 0, 55, 55);
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play_normal.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play_press.png"] forState:UIControlStateHighlighted];
    _playButton.center = CGPointMake(135, 135);
    [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [_boundsView addSubview:_playButton];
    
}
-(void)play:(UIButton*)button
{
    [self.view setUserInteractionEnabled:NO];
    [_imageview startAnimating];
    button.hidden = YES;
    [self performSelector:@selector(showPlayButton) withObject:nil afterDelay:_imageview.animationDuration];
}    
-(void)showPlayButton
{
    [self.view setUserInteractionEnabled:YES];
    _playButton.hidden = NO;
}
#pragma mark -
#pragma mark TopBar
-(void)addViewBar
{
    UIButton* backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(15, 15, 70, 40);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"camera_cancel.png"] forState:UIControlStateNormal];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"camera_cancel_2.png"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(gifbackTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(235, 15, 70, 40);
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"camera_next_normal.png"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"camera_next_press.png"] forState:UIControlStateHighlighted];
    [_saveButton addTarget:self action:@selector(saveGif:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
}

-(void)addTabBar
{
    UIImageView * bgview = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 431, 320, 49)] autorelease];
    bgview.image = [UIImage imageNamed:@"camera_bar.png"];
    bgview.tag = 5000;
    [bgview setUserInteractionEnabled:YES];
    [self.view addSubview:bgview];
    
    UIButton* cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cutButton.tag = 1000; 
    [cutButton setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateNormal];
    [cutButton setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateHighlighted];
    [cutButton addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    cutButton.frame = CGRectMake(24,4, 41, 41);
    [bgview addSubview:cutButton];
    
    UIButton* translate = [UIButton buttonWithType:UIButtonTypeCustom];
    translate.frame = CGRectMake(80 + 24, 4, 41, 41);
    translate.backgroundColor = [UIColor clearColor];
    translate.tag = 1001;
    [translate setBackgroundImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
    [translate setBackgroundImage:[UIImage imageNamed:@"random——2.png"] forState:UIControlStateHighlighted];
    
    [translate addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:translate];
    
    UIButton * fpbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    fpbutton.tag = 1002; 
    [fpbutton addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    fpbutton.frame = CGRectMake(160 + 24,4, 41, 41);
    [fpbutton setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateNormal];
    [fpbutton setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateHighlighted];
    [bgview addSubview:fpbutton];

    UIButton* _filterbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterbutton.tag = 1003; 
    _filterbutton.frame = CGRectMake(240 + 3, 4 , 62, 41);
    [self setFilterBackImage:_filterbutton];
    [_filterbutton addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:_filterbutton];
}
-(void)setFilterBackImage:(UIButton* )button
{
    NSLog(@"setFilterBackImage");
    if (isHiddenFitter) {
        [button setBackgroundImage:[UIImage imageNamed:@"特效.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"特效-2.png"] forState:UIControlStateHighlighted];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"特效-3.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"特效-4.png"] forState:UIControlStateHighlighted];
    }
    isHiddenFitter = !isHiddenFitter;
}
#pragma mark -
#pragma mark tabBarAction
-(void)resetButtonView
{
    
    UIImageView*bgview = (UIImageView*)[self.view viewWithTag:5000];
    UIButton* reszie = (UIButton*)[bgview viewWithTag:1000];
    UIButton* fpbutton =(UIButton*) [bgview viewWithTag:1002];
    [reszie setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateNormal];
    [reszie setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateHighlighted];
    
    [fpbutton setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateNormal];
    [fpbutton setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateHighlighted];

}
-(void)tabBarAction:(UIButton*)button
{
    switch (button.tag) {
        case 1000:
            //Resize
            
            [self initGifResize];
            if (_gifResize.view.superview) {
                [button setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"resize_normal.png"] forState:UIControlStateHighlighted];
                [_gifResize.view removeFromSuperview];
            }else {
                
                //remove other view
                if (_gifDuration.view.superview ) {
                    [_gifDuration.view removeFromSuperview];
                    [self resetButtonView];
                }
                if (_gifFitterBar.view.superview) {
                    [_gifFitterBar.view removeFromSuperview];
                    UIImageView * bgview = (UIImageView*)[self.view viewWithTag:5000];
                    UIButton* button = (UIButton*)[bgview viewWithTag:1003];
                    [self setFilterBackImage:button];
                }
                
                //add self view
                [button setBackgroundImage:[UIImage imageNamed:@"resize_press.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"resize_press.png"] forState:UIControlStateHighlighted];
                [self.view addSubview:_gifResize.view];
            }
            break;
        case 1001:
            //Trasnslate
            [self Ration];
            break;
        case 1002:
            //duration
            [self initGifDuration];
            
            if (_gifDuration.view.superview) {
                [button setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"speed_normal.png"] forState:UIControlStateHighlighted];

                [_gifDuration.view removeFromSuperview];
            }else {
                if (_gifResize.view.superview ) {
                    [_gifResize.view removeFromSuperview];
                    [self resetButtonView];
                }
                if (_gifFitterBar.view.superview) {
                    [_gifFitterBar.view removeFromSuperview];
                    UIImageView * bgview = (UIImageView*)[self.view viewWithTag:5000];
                    UIButton* button = (UIButton*)[bgview viewWithTag:1003];
                    [self setFilterBackImage:button];
                }
                [button setBackgroundImage:[UIImage imageNamed:@"speed_press.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"speed_press.png"] forState:UIControlStateHighlighted];

                [self.view addSubview:_gifDuration.view];
            }
            break;
        case 1003:
            //filter;
            if (_gifFitterBar == nil) {
                _gifFitterBar = [[FitterTabBar alloc] initWithdelegate:self];
                _gifFitterBar.view.frame = CGRectMake(0, self.view.frame.size.height - 144, 320, 100);
            }
            
            if (_gifFitterBar.view.superview) {
                [_gifFitterBar.view removeFromSuperview];
            }else {
                if (_gifDuration.view.superview || _gifResize.view.superview) {
                    [_gifResize.view removeFromSuperview];
                    [_gifDuration.view removeFromSuperview];
                    
                    [self resetButtonView];
                }
                [self.view addSubview:_gifFitterBar.view];
            }
            [self setFilterBackImage:button];
            break;
        default:
            break;
    }
}
-(void)initGifResize
{
    if (_gifResize == nil) {
        NSArray* Narray = [NSArray arrayWithObjects:@"resize_S_normal.png",@"resize_M_normal.png",@"resize_L_normal.png", nil];
        NSArray* Sarray = [NSArray arrayWithObjects:@"resize_S_press.png",@"resize_M_press.png",@"resize_L_press.png", nil];
        CGRect rect = CGRectMake(2, self.view.frame.size.height - 112, 274, 62);
        _gifResize = [[GifDetail alloc] initWithFrame:rect N_image:Narray S_image:Sarray];
        [_gifResize setBackImage:[UIImage imageNamed:@"resize_bg.png"]];
        _gifResize.delegate = self;
    }

}
-(void)initGifDuration
{
    if (_gifDuration == nil) {
        
        NSArray* Narray = [NSArray arrayWithObjects:@"speed_10_normal.png",@"speed_15_normal.png",@"speed_20_normal.png", nil];
        NSArray* Sarray = [NSArray arrayWithObjects:@"speed_10_press.png",@"speed_15_press.png",@"speed_20_press.png", nil];
        CGRect rect = CGRectMake(92, self.view.frame.size.height - 112, 223, 62);
        _gifDuration = [[GifDetail alloc] initWithFrame:rect N_image:Narray S_image:Sarray];
        [_gifDuration setBackImage:[UIImage imageNamed:@"speed_bg.png"]];
        _gifDuration.delegate = self;
    }
}
-(void)Ration
{
    CGAffineTransform newstransform = CGAffineTransformRotate(_imageview.transform, M_PI_2);
    _imageview.transform = newstransform;
    _rotate ++;
    _rotate %= 4; 
}
-(void)GifDetail:(GifDetail *)controller actionAtindex:(NSInteger)index
{
    if (controller == _gifDuration) {
        CGFloat duration = 0;
        switch (index) {
            case 0:
                duration = _durationTime;
                break;
            case 1:
                duration = _durationTime * 2/ 3 ;
                break;
                case 2:
                duration = _durationTime / 2;
                break;
            default:
                break;
        }
        NSLog(@"_gifDuration %f",duration);
        _imageview.animationDuration = duration;
    }
    if (controller == _gifResize) {
        CGFloat scale = 0.f;
        switch (index) {
            case 0:
                scale = 135.f/_boundsView.frame.size.width; 
                break;
            case 1:
                scale = 202.f/_boundsView.frame.size.width; 

                break;
            case 2:
                scale = 256.f/_boundsView.frame.size.width; 
                break;
            default:
                break;
        }
        NSLog(@"scale = 128.f/_imageview.frame.size.width ,%f",_boundsView.frame.size.width);
        _boundsView.transform = CGAffineTransformConcat(_boundsView.transform, CGAffineTransformMakeScale(scale, scale));
    }
}
-(void)fitterAction:(UIButton *)button
{
    if (button.tag == 500) {
        NSLog(@"fitterAction original");
        _imageview.animationImages = self.imageArray;
        _imageview.image = [_imageview.animationImages objectAtIndex:0];

    }else {

        if (_activity == nil) {
            _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _activity.center = CGPointMake(36.5, 36.5);
            _activity.color = [UIColor blackColor];
        }
        [_activity startAnimating];
        [button addSubview:_activity];
        [self fitterwithFittername:button.tag - 1000];
    }
}

-(void)fitterwithFittername:(NSInteger)filternum
{
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       [self.view setUserInteractionEnabled:NO];
       NSArray * array_s = [Filterlibrary cachedArrayDataForName:filternum];
       if (array_s) {
           NSLog(@"helloWorld");
           dispatch_async(dispatch_get_main_queue(), ^{
               _imageview.animationImages = array_s;
               _imageview.image = [_imageview.animationImages objectAtIndex:0];
               [_activity stopAnimating];
               [_activity removeFromSuperview];
               [self.view setUserInteractionEnabled:YES];
           });
           return ;
       }
       
       NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
       for (int i = 0; i < self.imageArray.count; i++) {
           UIImage * image = [self.imageArray objectAtIndex:i];
           [array addObject:[ImageUtil imageWithImage:image withMatrixNum:filternum]];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           _imageview.animationImages = array;
           _imageview.image = [_imageview.animationImages objectAtIndex:0];
           [_activity stopAnimating];
           [_activity removeFromSuperview];
           [self.view setUserInteractionEnabled:YES];
       });
       [Filterlibrary storeCachedOAuthArrayData:array forName:filternum];
   });
}
#pragma mark -
#pragma mark gif Function TopBar
-(void)gifbackTop:(UIButton*)button
{
    [_controller dismissModalViewControllerAnimated:YES];
}

-(void)saveGif:(UIButton*)button
{
    
    SCPAlert_WaitView *  _alterView = [[[SCPAlert_WaitView alloc] initWithImage:[UIImage imageNamed:@"pop_alert.png"] text:@"制作中" withView: self.view] autorelease];
    [_alterView show];
    
    [self.view setUserInteractionEnabled:NO];
    [self makeRation];
    [self makeResize];
    _imageview.image = [_imageview.animationImages objectAtIndex:0];
    //make gif
    FreeGifMaker * gifmaker = [[[FreeGifMaker alloc]init] autorelease];
    CGFloat delay = _imageview.animationDuration / _imageview.animationImages.count;
    [gifmaker setGifFrame:_imageview.animationImages delay:delay];
    NSData * data = [[[NSData alloc] initWithData:[gifmaker saveAnimatedGif]] autorelease];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"ImageData",_imageview.image,@"UIImagePickerControllerThumbnail",nil];
    [self.view setUserInteractionEnabled:YES];
    
    SCPUploadController *ctrl = [[[SCPUploadController alloc] initWithImageToUpload:[NSArray arrayWithObject:dic]:_controller] autorelease];
    [self.navigationController pushViewController:ctrl animated:YES];
    [_alterView dismissWithClickedButtonIndex:0 animated:YES];
    
}
-(void)makeRation
{
    if (_rotate == 0) {
        return;
    }
    NSLog(@"makeRation start");
    _imageview.animationImages = [UIImage imageByRotate:_imageview.animationImages :_rotate];
    _rotate = 0;
    NSLog(@"makeRation end");
}
-(void)makeResize
{
    if (_imageview.frame.size.width == 256) {
        return;
    }
    NSLog(@"makeResize start");
    _imageview.animationImages = [UIImage imageByScalingProportionallyToSize:_imageview.animationImages :_imageview.bounds.size];
    CGRect rect = _imageview.frame;
    _imageview.transform = CGAffineTransformIdentity;
    _imageview.frame = rect;
    NSLog(@"makeResize end");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
