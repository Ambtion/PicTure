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

#import "SCPWatiAlterView.h"

#define OFFSET 20


@class SCPPhotoListController;

@implementation InfoImageView

@synthesize info;
@synthesize actV;
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.actV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
        actV.hidesWhenStopped = YES;
        [self addSubview:actV];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.actV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
        actV.hidesWhenStopped = YES;
        [self addSubview:actV];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    actV.center = CGPointMake(self.frame.size.width/ 2.f, self.frame.size.height/2.f);
}
- (void)dealloc
{
    self.info = nil;
    self.actV = nil;
    [super dealloc];
}

@end
 


@implementation SCPPhotoListController

@synthesize info = _info;
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
    [_requestManger release];
    self.bgView = nil;
    self.scrollView = nil;
    self.fontImageView  = nil;
    self.fontScrollview = nil;
    self.currentImageView = nil;
    self.curscrollView  = nil ;
    self.rearImageView = nil;
    self.rearScrollview = nil;
    [imageArray release];
    [curImages release];
    self.info = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame useInfo:(NSDictionary * ) info : (PhotoDetailManager *)dataManager
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.view.backgroundColor = [UIColor redColor];
        
        _dataManager = dataManager;
        imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        curImages = [[NSMutableArray alloc] initWithCapacity:0];
        curPage = 0;
        Pagenum = 1;
        self.info = info;
        
        _requestManger = [[SCPRequestManager alloc] init];
        _requestManger.delegate = self;
        [self initSubViews];
        [_requestManger getPhotosWithUserID:[self.info objectForKey:@"creatorId"] FolderID:[info objectForKey:@"folderShowId"] page:Pagenum++];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}
#pragma mark Ratation
- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self initSubViews];
}

#pragma mark - Delegate
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    photoNum = [[[info objectForKey:@"folder"] objectForKey:@"photoNum"] intValue];
    [imageArray addObjectsFromArray:[info objectForKey:@"photoList"]];
    curPage =  [self getindexofImages];
    if (curPage == -1) {
        [self getMoreImage];
    }else{
        NSLog(@"curImage %d",curPage);
        NSLog(@"photo image : %d",photoNum);
        [self refreshScrollView];
    }
}
- (NSInteger)getindexofImages
{
    BOOL isFound = NO;
    int i = 0;
    for (i = 0; i < imageArray.count; i++) {
        NSDictionary * dic = [imageArray objectAtIndex:i];
        if ([[dic objectForKey:@"originUrl"] isEqual:[self.info objectForKey:@"originUrl"]]) {
            isFound = YES;
            NSLog(@"hello");
            break;
        }
    }
    if (isFound){
        return i;
    }
    return -1;
}
- (void)requestFailed:(SCPRequestManager *)mangeger
{
    NSLog(@"failed");
}
- (void)getMoreImage
{
    if (photoNum == imageArray.count) {
        return;
    }
    [_requestManger getPhotosWithUserID :[self.info objectForKey:@"creatorId"] FolderID:[_info objectForKey:@"folderShowId"] page:Pagenum++];
}
#pragma mark - InitSubView

- (void)initSubViews
{
    CGRect rect = self.view.frame;
    rect.size.width += OFFSET * 2;
    rect.origin.x -= OFFSET;
    
    self.bgView = [[UIView alloc] initWithFrame:rect];
    self.bgView.backgroundColor = [UIColor greenColor];
    [self.view  addSubview:self.bgView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bgView.bounds];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:self.scrollView];
    
    [self addFontScrollView];
    [self addCurScrollView];
    [self addrearScrollView];
    [self setScrollViewProperty];
    
}
- (void)addFontScrollView
{
    self.fontScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.bounds.size.height)];
    self.fontScrollview.delegate = self;
    self.fontScrollview.minimumZoomScale = 1.f;
    self.fontScrollview.maximumZoomScale = 2.f;
    self.fontScrollview.backgroundColor = [UIColor clearColor];
    self.fontScrollview.contentMode = UIViewContentModeCenter;
    
    self.fontImageView = [[InfoImageView alloc] initWithFrame:self.fontScrollview.bounds];
    self.fontImageView.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizeronView:self.fontScrollview];
    
    [self.fontScrollview  addSubview:self.fontImageView];
    self.curscrollView.showsHorizontalScrollIndicator = NO;
    self.curscrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.fontScrollview];
    
}
- (void)addCurScrollView
{
    self.curscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)];
    self.curscrollView.delegate = self;
    self.curscrollView.minimumZoomScale  = 1.f;
    self.curscrollView.backgroundColor = [UIColor clearColor];
    self.curscrollView.contentMode = UIViewContentModeCenter;
    
    [self.scrollView addSubview:self.curscrollView];
    self.currentImageView = [[InfoImageView alloc] initWithFrame:self.curscrollView.bounds];
    self.currentImageView.backgroundColor = [UIColor clearColor];
    
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
    
    self.rearScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * 2 + OFFSET, 0, self.scrollView.frame.size.width - OFFSET * 2, self.scrollView.frame.size.height)];
    self.rearScrollview.delegate = self;
    
    self.rearScrollview.minimumZoomScale = 1.f;
    self.rearScrollview.maximumZoomScale  = 2.f;
    
    self.rearScrollview.backgroundColor = [UIColor clearColor];
    self.rearScrollview.contentMode = UIViewContentModeCenter;
    
    self.rearImageView = [[InfoImageView alloc] initWithFrame:self.rearScrollview.bounds];
    self.rearImageView.backgroundColor = [UIColor clearColor];
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
    
    _dataManager.photo_ID = [self.info objectForKey:@"showId"];
    [_dataManager dataSourcewithRefresh:YES];
    
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:[self getCurrentImageView].bounds] autorelease];
    imageView.image = [self getCurrentImageView].image;    
    
    UIView * boundsView = [[[UIView alloc] initWithFrame:[self getCurrentImageView].frame] autorelease];
    boundsView.backgroundColor = [UIColor clearColor];
    boundsView.clipsToBounds = YES;
    [boundsView addSubview:imageView];
    
    CGFloat heigth = [self getHeightofImage:[[self.info objectForKey:@"height"] floatValue] :[[self.info objectForKey:@"width"] floatValue]];
    CGRect photoRect = CGRectZero;
    CGRect boundsRect = CGRectZero;
    
    [self setTempRect:&boundsRect PhotoRect:&photoRect with:heigth];
    
    self.view.alpha = 0;
    
    SCPAppDelegate * app = (SCPAppDelegate *)[UIApplication sharedApplication].delegate;
    UIView * bgview = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    bgview.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:bgview];
    [app.window addSubview:boundsView];
    
    [((SCPMenuNavigationController *) (self.navigationController)).menuManager.ribbon setHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        boundsView.frame = boundsRect;
        imageView.frame = photoRect;
        bgview.alpha = 0;
    } completion:^(BOOL finished) {
        [boundsView removeFromSuperview];
        [bgview removeFromSuperview];
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
    //    NSLog(@"finalHeigth %f",finalHeigth);
    if (!finalHeigth) {
        finalHeigth = 320;
    }
    return finalHeigth;
}
- (UIImageView *)getCurrentImageView
{
    UIImageView * view = nil;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width)
        view =  self.currentImageView;
    if (self.scrollView.contentOffset.x == 0)
        view = self.fontImageView;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * 2)
        view = self.rearImageView;
    return view;
}
- (void)showWithPushController:(id)nav_ctrller fromRect:(CGRect)temRect image:(UIImage *)image ImgaeRect:(CGRect)imageRect 
{
    
    UIView * boundsView = [[[UIView alloc] initWithFrame:temRect] autorelease];
    boundsView.backgroundColor = [UIColor clearColor];
    boundsView.clipsToBounds = YES;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = imageRect;
    [boundsView addSubview:imageView];
    
    SCPAppDelegate * app = (SCPAppDelegate *)[UIApplication sharedApplication].delegate;
    UIView * view = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    view.backgroundColor = [UIColor blackColor];
    
    view.alpha = 0;
    [app.window addSubview:view];
    [app.window addSubview:boundsView];
    
    CGRect finRect = [self getCurrentImageView].frame;
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        boundsView.frame = finRect;
        imageView.frame = [self getCurrentImageView].bounds;
        view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [((SCPMenuNavigationController *) (nav_ctrller)).menuManager.ribbon setHidden:YES];
        [nav_ctrller pushViewController:self animated:NO];
        [view removeFromSuperview];
        [boundsView removeFromSuperview];
    }];
    
}
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if ([[gesture view] isEqual:self.fontScrollview]) {
        NSLog(@"%s , scale :%f",__FUNCTION__ ,self.fontScrollview.maximumZoomScale);
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
    
    
    //    if(value == -1) value = imageArray.count - 1;                   // value＝1为第一张，value = 0为前面一张
    //    if(value == imageArray.count){
    //        if (imageArray.count == photoNum ) value = 0;
    //
    //    }
    return value;
}
- (void)resetImageFrame:(InfoImageView*)imageView
{
    
    CGFloat w = [[[imageView info] objectForKey:@"width"] floatValue];
    CGFloat h = [[[imageView info] objectForKey:@"height"] floatValue];
    
    CGRect frameRect = self.scrollView.frame;
    frameRect.size.width -= 2  * OFFSET;
    
    [self.curscrollView  setZoomScale:1];
    [self.fontScrollview setZoomScale:1];
    [self.rearScrollview setZoomScale:1];
    
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
        }    }else{
            
            if ([imageView isEqual:self.currentImageView]){
                self.curscrollView.maximumZoomScale = 1.1;
            }
            if ([imageView isEqual:self.fontImageView]) {
                self.fontScrollview.maximumZoomScale = 1.1;
            }
            if ([imageView isEqual:self.rearImageView]) {
                self.rearScrollview.maximumZoomScale = 1.1;
            }
            
            rect = CGRectMake(0, 0, w, h);
        }
    
    imageView.frame = rect;
    imageView.center  = CGPointMake(frameRect.size.width  / 2.f, frameRect.size.height / 2.f);
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
    
    [imageView cancelCurrentImageLoad];
    [imageView.actV startAnimating];
    [imageView setImageWithURL:[NSURL URLWithString:[[imageView info] objectForKey:@"originUrl"]] placeholderImage:nil options:0  success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView.actV stopAnimating];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)refreshScrollviewOnMinBounds
{
    self.fontImageView.info = [imageArray objectAtIndex:0];
    if (imageArray.count > 2) {
        self.rearImageView.info = [imageArray objectAtIndex:2];
    }else{
        self.rearImageView.info = nil;
    }
    if (imageArray.count > 1) {
        self.currentImageView.info = [imageArray objectAtIndex:1];
    }else{
        self.currentImageView.info  = nil;
    }
    self.info = self.fontImageView.info;
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    
    if (photoNum < 3) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, self.scrollView.frame.size.width, 0, 0)];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * photoNum, self.scrollView.frame.size.height)];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0)];
    }
    if (photoNum < 3) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * photoNum, self.scrollView.frame.size.height)];
    }
    
    [self.scrollView setContentOffset:CGPointZero];
}
- (void)refreshScrollviewOnMaxBounds
{
    self.rearImageView.info = [imageArray lastObject];
    if (imageArray.count > 2) {
        self.fontImageView.info = [imageArray objectAtIndex:imageArray.count - 3];
    }else{
        self.fontImageView.info = nil;
    }
    if (imageArray.count > 1) {
        self.currentImageView.info = [imageArray objectAtIndex:imageArray.count - 2];
    }else{
        self.currentImageView.info  = nil;
    }
    self.info = self.fontImageView.info;
    [self resetImageFrame:self.fontImageView];
    [self resetImageFrame:self.currentImageView];
    [self resetImageFrame:self.rearImageView];
    if (photoNum < 3) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, self.scrollView.frame.size.width, 0, 0)];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * photoNum, self.scrollView.frame.size.height)];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0)];
    
}
- (void)refreshScrollView {
    
    NSLog(@"photoNum:%d imageCount::%d  curnum: %d",photoNum, imageArray.count, curPage);
    if (curPage == 0) {
        [self refreshScrollviewOnMinBounds];
        return;
    }
    if (curPage == imageArray.count - 1) {
        [self refreshScrollviewOnMaxBounds];
        return;
    }
    
    if ([self getDisplayImagesWithCurpage:curPage]) {
        
        self.fontImageView.info = [curImages objectAtIndex:0];
        self.currentImageView.info = [curImages objectAtIndex:1];
        self.rearImageView.info = [curImages objectAtIndex:2];
        self.info = self.currentImageView.info;
        
        [self resetImageFrame:self.fontImageView];
        [self resetImageFrame:self.currentImageView];
        [self resetImageFrame:self.rearImageView];
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}

#pragma mark scrollView  Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (![scrollView isEqual:self.scrollView]) {
        return;
    }
    int x = scrollView.contentOffset.x;
    if(x >= (self.scrollView.frame.size.width * 2)) {
        
        if (curPage >= photoNum - 2) {
            self.info = self.rearImageView.info;
            [self resetImageFrame:self.rearImageView];
            return;
        }
        if (curPage == imageArray.count - 2) {
            [self getMoreImage];
            return;
        }
        curPage = [self validPageValue:curPage+1];
        [self refreshScrollView];
    }
    if(x <= 0) {
        
        if (curPage <= 1) {
            self.info = self.fontImageView.info;
            [self resetImageFrame:self.fontImageView];
            return;
        }
        curPage = [self validPageValue:curPage-1];
        [self refreshScrollView];
    }
    if (x == self.scrollView.frame.size.width) {
        self.info = self.currentImageView.info;
        [self resetImageFrame:self.currentImageView];
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
    UIView * view = [[scrollView subviews] lastObject];
    if ([scrollView isEqual:self.curscrollView]) {
        
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
    
}
@end
