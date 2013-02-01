//
//  SCPPhotoListScrollview.m
//  UISCrollView_NetWork
//
//  Created by sohu on 12-11-26.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import "SCPPhotoListController.h"
#import "SCPAppDelegate.h"
#import "SCPPhotoDetailViewController.h"
#import "SCPMenuNavigationController.h"

#define OFFSET 20

@class SCPPhotoListController;

@implementation InfoImageView
@synthesize info;
@synthesize actV;
@synthesize webView;
@synthesize requset;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews
{
    self.actV = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
    actV.hidesWhenStopped = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:actV];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
}

- (void)playGif:(NSURL *)url
{
    
    self.webView = [[[UIWebView alloc] initWithFrame:self.frame] autorelease];
    self.webView.userInteractionEnabled = NO;//用户不可交互
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:self.webView];
    [self.superview sendSubviewToBack:self.webView];
    NSData * data = nil;
    NSFileManager * manager  = [NSFileManager defaultManager];
    NSString * str = [self getStringWithURL:url];
    if ([manager fileExistsAtPath:str]){
        data = [NSData dataWithContentsOfFile:str];
    }
    if (data) {
        [self.webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }else{
        [self.requset clearDelegatesAndCancel];
        self.requset = [ASIHTTPRequest requestWithURL:url];
        self.requset.delegate = self;
        [self.requset setTimeOutSeconds:5.f];
        [self.requset startAsynchronous];
    }
}
#pragma mark -RequseDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData * data = [requset responseData];
    if (self.webView)
        [self.webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    NSFileManager * manager  = [NSFileManager defaultManager];
    NSString * str = [self getStringWithURL:requset.url];
    if ([manager fileExistsAtPath:str])
        [manager removeItemAtPath:str error:nil];
    NSError * error = nil;
    [data writeToFile:str options:NSDataWritingAtomic error:&error];
}
- (NSString *)getStringWithURL:(NSURL *)url
{
    NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSArray * array = [[url absoluteString] componentsSeparatedByString:@"/"];
    str = [str stringByAppendingFormat:@"/%@", [array lastObject]];
    return str;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [requset clearDelegatesAndCancel];
    [self.actV stopAnimating];
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.superview bringSubviewToFront:self.webView];
}

- (void)resetGigView
{
    [self.requset clearDelegatesAndCancel];
    [self.requset cancel];
    self.requset = nil;
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    self.webView = nil;
}
- (void)dealloc
{
    [self cancelCurrentImageLoad];
    [self resetGigView];
    self.info = nil;
    self.actV = nil;
    self.webView = nil;
    self.requset = nil;
    [super dealloc];
    
}
@end

@implementation SCPPhotoListController
@synthesize delegate = _delegate;
@synthesize tempView;
@synthesize info = _info;
@synthesize folder_id = _folder_id;
@synthesize user_id = _user_id;
@synthesize bgView = _bgView;
@synthesize scrollView = _scrollView;
@synthesize fontScrollview = _fontScrollview;
@synthesize fontImageView = _fontImageView;
@synthesize curscrollView = _curscrollView;
@synthesize currentImageView = _currentImageView;
@synthesize rearImageView = _rearImageView;
@synthesize rearScrollview = _rearScrollview;

- (void)dealloc
{
    if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications])
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_requestManger setDelegate:nil];
    [_requestManger release];
    self.tempView = nil;
    self.bgView = nil;
    self.scrollView = nil;
    self.fontImageView  = nil;
    self.fontScrollview = nil;
    self.currentImageView = nil;
    self.curscrollView  = nil ;
    self.rearImageView = nil;
    self.rearScrollview = nil;
    self.folder_id = nil;
    self.user_id = nil;
    [imageArray release];
    [curImages release];
    self.info = nil;
    [super dealloc];
    
}

- (id)initWithUseInfo:(NSDictionary * ) info : (PhotoDetailManager *)dataManager
{
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        self.view.backgroundColor = [UIColor blackColor];
        _dataManager = dataManager;
        imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        curImages = [[NSMutableArray alloc] initWithCapacity:0];
        curPage = 0;
        Pagenum = 1;
        animation = NO;
        hasNextPage = YES;
        self.info = info;
        isInit = YES;
        isLoading = NO;
        
        _requestManger = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
        [self initSubViews];
        [self.view setUserInteractionEnabled:NO];
        self.folder_id = [NSString stringWithFormat:@"%@",[info objectForKey:@"folder_id"]];
        self.user_id = [NSString stringWithFormat:@"%@",[self.info objectForKey:@"user_id"]];
        [_requestManger getFolderinfoWihtUserID:self.user_id WithFolders:self.folder_id];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(listOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark Ratation
- (CGAffineTransform )getTransfrom
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsPortrait(orientation))
        return CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft)
        return CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    if (orientation == UIInterfaceOrientationLandscapeRight)
        return CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    return CGAffineTransformIdentity;
}
- (CGSize)getIdentifyImageSizeWithImageView:(InfoImageView *)imageView isPortraitorientation:(BOOL)isPortrait
{
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    CGRect frameRect = CGRectZero;
    CGRect  screenFrame = [[UIScreen mainScreen] bounds];
    if (isPortrait) {
        frameRect = screenFrame;
    }else{
        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    }
    CGRect rect = CGRectZero;
    if (w > frameRect.size.width || h > frameRect.size.height) {
        CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
        rect = CGRectMake(0, 0, w * scale, h * scale);
    }else{
        rect = CGRectMake(0, 0, w, h);
    }
    return rect.size;
}
- (void)listOrientationChanged:(NSNotification *)notification
{
    
    if (isInit) return;
    if ([[self.currentImageView.info objectForKey:@"multi_frames"]boolValue]) return;
    [self.view setUserInteractionEnabled:NO];
    animation = YES;
    CGFloat scale = 1.0;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (CGAffineTransformEqualToTransform([self getTransfrom], CGAffineTransformIdentity)) {
        transform = CGAffineTransformInvert(self.view.transform);
        CGSize identifySzie = [self getIdentifyImageSizeWithImageView:(InfoImageView *)[self getCurrentImageView] isPortraitorientation:YES];
        scale = MIN( identifySzie.width / [self getCurrentImageView].frame.size.width, identifySzie.height / [self getCurrentImageView].frame.size.height);
    }else{
        CGSize identifySzie = [self getIdentifyImageSizeWithImageView:(InfoImageView *)[self getCurrentImageView] isPortraitorientation:NO];
        scale = MIN( identifySzie.width / [self getCurrentImageView].frame.size.width, identifySzie.height / [self getCurrentImageView].frame.size.height);
        transform = [self getTransfrom];
    }
    transform  = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(scale, scale));
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut    animations:^{
        [self getCurrentImageView].transform = transform;
    } completion:^(BOOL finished) {
        self.view.transform = [self getTransfrom];
        if (CGAffineTransformEqualToTransform(self.view.transform, CGAffineTransformIdentity))
            self.view.frame = [UIScreen mainScreen].bounds;
        animation = NO;
        [self initSubViews];
        [self.view setUserInteractionEnabled:YES];
    }];
}

#pragma mark - Delegate
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    isLoading = NO;
    NSDictionary * folderinfo = [info objectForKey:@"folderInfo"];
    NSDictionary * photolist = [info objectForKey:@"photoList"];
    if ([folderinfo allKeys]) {
        photoNum = [[folderinfo objectForKey:@"photo_num"] intValue];
        if (!photoNum) {
            [self requestFailed:nil];
            return;
        }
    }
    Pagenum = [[photolist objectForKey:@"page"] intValue];
    hasNextPage = [[photolist objectForKey:@"has_next"] boolValue];
    [imageArray addObjectsFromArray:[photolist objectForKey:@"photos"]];
    curPage =  [self getindexofImages];
    [self.view setUserInteractionEnabled:YES];
    
    if (curPage == -1){
        [self getMoreImage];
    }else{
        [self refreshScrollView];
        isInit = NO;
    }
}

- (void)requestFailed:(NSString *)error
{
    isLoading = NO;
    [self.view setUserInteractionEnabled:YES];
    if (!imageArray.count){
        [imageArray addObject:self.info];
        photoNum = 1;
        curPage = 0;
    }else{
        if (curPage == -1)
            curPage = 0;
    }
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:@"专辑加载失败,请稍后在试"] autorelease];
    [alertView show];
    [self refreshScrollView];
    isInit = NO;
}

- (NSInteger)getindexofImages
{
    BOOL isFound = NO;
    int i = 0;
    for (; i < imageArray.count; i++) {
        NSDictionary * dic = [imageArray objectAtIndex:i];
        if ([[dic objectForKey:@"photo_url"] isEqual:[self.info objectForKey:@"photo_url"]]) {
            isFound = YES;
            break;
        }
    }
    if (isFound){
        return i;
    }
    return -1;
}

- (void)getMoreImage
{
    if (photoNum <= imageArray.count || isLoading || !hasNextPage)  return;
    isLoading = YES;
    [self.view setUserInteractionEnabled:NO];
    [_requestManger getPhotosWithUserID :self.user_id FolderID:self.folder_id page:Pagenum + 1];
}
#pragma mark - InitSubView

- (void)initSubViews
{
    CGRect rect = self.view.frame;
    rect.size.width += OFFSET * 2;
    rect.origin.x -= OFFSET;
    self.bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:self.bgView];
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bgView.bounds] autorelease];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:self.scrollView];
    
    [self addFontScrollView];
    [self addCurScrollView];
    [self addrearScrollView];
    
    [self setScrollViewProperty];
    [self refreshScrollView];
    
}
- (void)addFontScrollView
{
    self.fontScrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.bounds.size.height)] autorelease];
    self.fontScrollview.delegate = self;
    self.fontScrollview.minimumZoomScale = 1.f;
    self.fontScrollview.backgroundColor = [UIColor clearColor];
    self.fontScrollview.contentMode = UIViewContentModeCenter;
    
    [self.scrollView addSubview:self.fontScrollview];
    self.fontImageView = [[[InfoImageView alloc] initWithFrame:self.fontScrollview.bounds] autorelease];
    [self addGestureRecognizeronView:self.fontScrollview];
    
    [self.fontScrollview  addSubview:self.fontImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    
}
- (void)addCurScrollView
{
    self.curscrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)] autorelease];
    self.curscrollView.delegate = self;
    self.curscrollView.minimumZoomScale  = 1.f;
    self.curscrollView.backgroundColor = [UIColor clearColor];
    self.curscrollView.contentMode = UIViewContentModeCenter;
    [self.scrollView addSubview:self.curscrollView];
    self.currentImageView = [[[InfoImageView alloc] initWithFrame:self.curscrollView.bounds] autorelease];
    [self addGestureRecognizeronView:self.curscrollView];
    [self.curscrollView addSubview:self.currentImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    self.currentImageView.info =  self.info;
    [self resetImageFrame:self.currentImageView];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}
- (void)addrearScrollView
{
    
    self.rearScrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * 2 + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)] autorelease];
    self.rearScrollview.delegate = self;
    self.rearScrollview.minimumZoomScale = 1.f;
    self.rearScrollview.contentMode = UIViewContentModeCenter;
    self.rearImageView = [[[InfoImageView alloc] initWithFrame:self.rearScrollview.bounds] autorelease];
    [self addGestureRecognizeronView:self.rearScrollview];
    [self.rearScrollview  addSubview:self.rearImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.rearScrollview];
}
- (void)addGestureRecognizeronView:(UIView *)view
{
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    gesture.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer * gesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlesignalGesture:)] autorelease];
    gesture1.numberOfTapsRequired = 1;
    [gesture1 requireGestureRecognizerToFail:gesture];
    [view addGestureRecognizer:gesture1];
    [view addGestureRecognizer:gesture];
    
}

#pragma mark TapGesture

- (void)handlesignalGesture:(UITapGestureRecognizer *)gesture
{
    [self.view setUserInteractionEnabled:NO];
    _dataManager.photo_ID = [NSString stringWithFormat:@"%@",[self.info objectForKey:@"photo_id"]];
    [_dataManager dataSourcewithRefresh:YES];
    animation = YES;
    [_dataManager.controller showNavigationBar];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [[[gesture view].subviews objectAtIndex:0] setAlpha:0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [self.tempView removeFromSuperview];
        animation = NO;
        
        if ([_delegate respondsToSelector:@selector(whenViewRemveFromSuperview)]) {
            [_delegate performSelector:@selector(whenViewRemveFromSuperview)];
        }
    }];
}
- (void)setTempRect:(CGRect *)tempRect PhotoRect:(CGRect *)photoRect with:(CGFloat)heigth
{
    if (heigth < 320) {
        CGFloat width = 320.f * (320.f / heigth);
        *photoRect  = CGRectMake((320 - width)/2.f, 0, width, 320);
        *tempRect = CGRectMake(0, 0, 320, 320);
    }else if(heigth > 320){
        *photoRect = CGRectMake(0, 0, 320, heigth);
        *tempRect = CGRectMake(0, 0, 320, 320);
        
    }else{
        *photoRect = CGRectMake(0, 0, 320,320);
        *tempRect = CGRectMake(0, 0, 320, 320);
    }
    CGFloat Y = ((SCPPhotoDetailViewController *)_dataManager.controller).pullingController.tableView.contentOffset.y;
    (*tempRect).origin.y -= (Y - 100);
}
- (CGFloat)getHeightofImage:(CGFloat)O_height :(CGFloat) O_width
{
    CGFloat finalHeigth = 0.f;
    finalHeigth = O_height * (320.f / O_width);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}
- (UIImageView *)getCurrentImageView
{
    UIImageView * view = nil;
    if (self.scrollView.contentOffset.x == 0)
        view = self.fontImageView;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width)
        view = self.currentImageView;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * 2)
        view = self.rearImageView;
    return view;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
    animation = NO;
    [self.view setUserInteractionEnabled:YES];
}
- (void)showWithPushController:(id)nav_ctrller fromRect:(CGRect)temRect image:(UIImage *)image ImgaeRect:(CGRect)imageRect
{
    
    self.tempView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tempView.backgroundColor = [UIColor blackColor];
    [self.view setUserInteractionEnabled:NO];
    animation = YES;
    
    CATransition * startAnimations = [CATransition animation];
    startAnimations.type = kCATransitionFade;
    startAnimations.duration = 0.5;
    startAnimations.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.30 :0 :0.6 :0.8];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.tempView];
    startAnimations.delegate = self;
    [[[[[UIApplication sharedApplication] delegate] window] layer] addAnimation:startAnimations forKey:@"KO"];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if ([[gesture view] isEqual:self.fontScrollview]) {
        if (self.fontScrollview.zoomScale != self.fontScrollview.maximumZoomScale) {
            [self.fontScrollview setZoomScale:self.fontScrollview.maximumZoomScale animated:YES];
        }else{
            [self.fontScrollview setZoomScale:self.fontScrollview.minimumZoomScale animated:YES];
        }
    }
    if ([[gesture view] isEqual:self.curscrollView]) {
        if (self.curscrollView.zoomScale != self.curscrollView.maximumZoomScale) {
            [self.curscrollView setZoomScale:self.curscrollView.maximumZoomScale animated:YES];
        }else{
            [self.curscrollView setZoomScale:self.curscrollView.minimumZoomScale animated:YES];
        }
    }
    if ([[gesture view] isEqual:self.rearScrollview]) {
        if (self.rearScrollview.zoomScale != self.rearScrollview.maximumZoomScale) {
            [self.rearScrollview setZoomScale:self.rearScrollview.maximumZoomScale animated:YES];
        }else{
            [self.rearScrollview setZoomScale:self.rearScrollview.minimumZoomScale animated:YES];
        }
    }
}
#pragma mark Refresh ScrollView
- (void)setScrollViewProperty
{
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3 , self.scrollView.bounds.size.height);
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
}
- (BOOL)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    [curImages addObject:[imageArray objectAtIndex:pre]];
    [curImages addObject:[imageArray objectAtIndex:curPage]];
    [curImages addObject:[imageArray objectAtIndex:last]];
    return YES;
    
}
- (int)validPageValue:(NSInteger)value {
    
    if(value <= 0) value = 0;                   // value＝1为第一张，value = 0为前面一张
    if(value >= imageArray.count) value = imageArray.count - 1;
    return value;
}
- (void)resetRect:(InfoImageView *)imageView
{
    
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    CGRect frameRect = self.scrollView.frame;
    frameRect.size.width -= 2  * OFFSET;
    CGRect rect = CGRectZero;
    if (w > frameRect.size.width || h > frameRect.size.height) {
        CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
        rect = CGRectMake(0, 0, w * scale, h * scale);
    }else{
        rect = CGRectMake(0, 0, w, h);
    }
    imageView.frame = rect;
    imageView.center  = CGPointMake(frameRect.size.width  / 2.f, frameRect.size.height / 2.f);
    if ([[[imageView info] objectForKey:@"multi_frames"] boolValue]){
        imageView.frame = CGRectMake(0, 0, w, h);
        imageView.center  = CGPointMake(frameRect.size.width  / 2.f, frameRect.size.height / 2.f);
    }
}

- (void)resetImageScale:(InfoImageView *)imageView
{
    
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    CGRect frameRect = self.scrollView.frame;
    frameRect.size.width -= 2  * OFFSET;
    
    CGRect rect = CGRectZero;
    if (w > frameRect.size.width || h > frameRect.size.height) {
        CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
        rect = CGRectMake(0, 0, w * scale, h * scale);
        if ([imageView isEqual:self.currentImageView]){
            self.curscrollView.maximumZoomScale = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }
        if ([imageView isEqual:self.fontImageView]) {
            self.fontScrollview.maximumZoomScale  = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }
        if ([imageView isEqual:self.rearImageView]) {
            self.rearScrollview.maximumZoomScale  = MIN(frameRect.size.width * 2 / rect.size.width, frameRect.size.height * 2 / rect.size.height);
        }
    }else{
        if ([imageView isEqual:self.currentImageView]){
            self.curscrollView.maximumZoomScale = 1.1;
        }
        if ([imageView isEqual:self.fontImageView]) {
            self.fontScrollview.maximumZoomScale = 1.1;
        }
        if ([imageView isEqual:self.rearImageView]) {
            self.rearScrollview.maximumZoomScale = 1.1;
        }
    }
}
- (void)resetImageFrame:(InfoImageView*)imageView
{
    if (!imageView.info) {
        return;
    }
    [self.curscrollView  setZoomScale:1];
    [self.fontScrollview setZoomScale:1];
    [self.rearScrollview setZoomScale:1];
    
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    CGRect frameRect = self.scrollView.frame;
    
    frameRect.size.width -= 2  * OFFSET;
    [self resetRect:imageView];
    
    if ([imageView isEqual:self.currentImageView]) {
        self.curscrollView.contentSize = imageView.frame.size;
        [self.curscrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if ([imageView isEqual:self.fontImageView]) {
        self.fontScrollview.contentSize = imageView.frame.size;
        [self.fontScrollview setContentOffset:CGPointMake(0, 0)];
    }
    if ([imageView isEqual:self.rearImageView]) {
        self.rearScrollview.contentSize = imageView.frame.size;
        [self.rearScrollview setContentOffset:CGPointMake(0, 0)];
    }
    
    [imageView resetGigView];
    [self resetModel:imageView];
    if (![[[imageView info] objectForKey:@"multi_frames"] boolValue])
        [imageView.actV startAnimating];
    
    NSString * str = nil;
    if (h > w) {
        str = [NSString stringWithFormat:@"%@_h960",[[imageView info] objectForKey:@"photo_url"]];
    }else{
        str = [NSString stringWithFormat:@"%@_w640",[[imageView info] objectForKey:@"photo_url"]];
    }
    
    [imageView cancelCurrentImageLoad];
    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options: 0 success:^(UIImage *image) {
        [imageView.actV stopAnimating];
        [self resetImageScale:imageView];
        if ([[[imageView info] objectForKey:@"multi_frames"] boolValue]){
            [self setModelForGif:imageView];
            [imageView playGif:[NSURL URLWithString:[imageView.info objectForKey:@"photo_url"]]];
        }
    } failure:^(NSError *error) {
        
        if ([[[imageView info] objectForKey:@"multi_frames"] boolValue]){
            [self setModelForGif:imageView];
            [imageView playGif:[NSURL URLWithString:[imageView.info objectForKey:@"photo_url"]]];
        }
    }];
}
- (void)setModelForGif:(InfoImageView *)imageView
{
    ((UIScrollView *)imageView.superview).scrollEnabled = NO;
    ((UIScrollView *)imageView.superview).maximumZoomScale = 1.f;
}
- (void)resetModel:(InfoImageView *)imageView
{
    ((UIScrollView *)imageView.superview).scrollEnabled = YES;
    ((UIScrollView *)imageView.superview).maximumZoomScale = 1.f;
}
- (void)refreshScrollviewOnMinBounds
{
    
    self.fontImageView.info = [imageArray objectAtIndex:0];
    self.currentImageView.info = [imageArray objectAtIndex:1];
    self.rearImageView.info = [imageArray objectAtIndex:2];
    self.info = self.fontImageView.info;
    
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    
    [self.scrollView setContentOffset:CGPointZero];
    Imagestate = AtLess;
    
}
- (void)refreshScrollviewOnMaxBounds
{
    //    NSLog(@"%s %d",__FUNCTION__,curPage);
    self.rearImageView.info = [imageArray objectAtIndex:imageArray.count - 1];
    self.currentImageView.info = [imageArray objectAtIndex:imageArray.count - 2];
    self.fontImageView.info = [imageArray objectAtIndex:imageArray.count - 3];
    self.info = self.rearImageView.info;
    
    [self resetImageFrame:self.rearImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.fontImageView];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2,0)];
    Imagestate = AtMore;
    
}

- (void)refreshScrollviewWhenPhotonumLessThree
{
    self.fontImageView.info = [imageArray objectAtIndex:0];
    if (imageArray.count == 2) {
        self.currentImageView.info = [imageArray objectAtIndex:1];
    }else if(imageArray.count == 3){
        self.currentImageView.info = [imageArray objectAtIndex:1];
        self.rearImageView.info = [imageArray objectAtIndex:2];
    }else{
        self.currentImageView.info = nil;
        self.rearImageView.info = nil;
    }
    self.info = [imageArray objectAtIndex:curPage];
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * photoNum, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * curPage, 0)];
    
}

- (void)refreshScrollViewNormal
{
    //    NSLog(@"%s %d",__FUNCTION__,curPage);
    if ([self getDisplayImagesWithCurpage:curPage]) { //read images into curImages
        self.fontImageView.info = [curImages objectAtIndex:0];
        self.currentImageView.info = [curImages objectAtIndex:1];
        self.rearImageView.info = [curImages objectAtIndex:2];
        self.info = self.currentImageView.info;
        [self resetImageFrame:self.currentImageView];
        [self resetImageFrame:self.fontImageView];
        [self resetImageFrame:self.rearImageView];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    }
    Imagestate = AtNomal;
}

- (void)refreshScrollView
{
    
    if (!imageArray || imageArray.count == 0) return;
    [self.view setUserInteractionEnabled:NO];
    if (photoNum <= 3) {
        [self refreshScrollviewWhenPhotonumLessThree];
    }else if (curPage == 0) {
        [self refreshScrollviewOnMinBounds];
    }else if (curPage == imageArray.count - 1) {
        [self refreshScrollviewOnMaxBounds];
    }else{
        [self refreshScrollViewNormal];
    }
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark scrollView  Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (isLoading || animation)  return;
    if (![scrollView isEqual:self.scrollView] || ![scrollView isDragging])      return;
    
    if (photoNum <= 3) {
        curPage = self.scrollView.contentOffset.x / self.view.frame.size.width;
        self.info = [imageArray objectAtIndex:curPage];
        return;
    }
    int x = self.scrollView.contentOffset.x;
    if (x == self.scrollView.frame.size.width) {
        //        NSLog(@"%s %d",__FUNCTION__,Imagestate);
        if (Imagestate != AtNomal) {
            if (Imagestate == AtLess) curPage++;
            if (Imagestate == AtMore) curPage--;
            Imagestate = AtNomal;
            [self refreshScrollView];
        }
        return;
        
        //        if (curPage == 0) {
        //            curPage = 1;
        //            [self refreshScrollView];
        //            return;
        //        }
        //        if (curPage == photoNum - 1) {
        //            curPage = photoNum - 2;
        //            [self refreshScrollView];
        //            return;
        //        }
    }
    
    if(x == (self.scrollView.frame.size.width * 2)) {
        curPage = [self validPageValue:curPage + 1];
        [self refreshScrollView];
        if (curPage >= imageArray.count - 1 && imageArray.count <= photoNum)  [self getMoreImage];
        return;
    }
    
    if(x == 0) {
        curPage = [self validPageValue:curPage - 1];
        [self refreshScrollView];
    }
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.curscrollView]) {
        return self.currentImageView;
    }
    if ([scrollView isEqual:self.fontScrollview]) {
        return self.fontImageView;
    }
    if ([scrollView isEqual:self.rearScrollview]) {
        return self.rearImageView;
    }
    return nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self resetImagetView:scrollView];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self resetImagetView:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetImagetView:scrollView];
}
- (void)resetImagetView:(UIScrollView *)scrollView
{
    
    UIImageView * view = [self getCurrentImageView];
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    if (view.frame.size.width > scrollView.frame.size.width){
        x = 0;
        offsetX = (view.frame.size.width - scrollView.frame.size.width)/2.f;
    }else{
        offsetX = 0;
        x = (scrollView.frame.size.width - view.frame.size.width)/ 2;
    }
    if (view.frame.size.height > scrollView.frame.size.height){
        y = 0;
        offsetY = ( view.frame.size.height - scrollView.frame.size.height)/2.f;
    }else{
        offsetY = 0;
        y = (scrollView.frame.size.height - view.frame.size.height)/2.f;
    }
    scrollView.contentOffset = CGPointMake(offsetX , offsetY);
    view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
    scrollView.contentSize = view.frame.size;
}
@end
