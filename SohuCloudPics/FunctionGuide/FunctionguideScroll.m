//
//  FunctionguideScroll.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import "FunctionguideScroll.h"
#import "SCPAppDelegate.h"

static NSString * staticImage[4] = {@"welcome-guid-1.png",@"cloud-2.png",@"camera-3.png",@"share_happy-4.png"};
#define PAGENUM 4
@interface FunctionguideScroll ()

@end

@implementation FunctionguideScroll
- (void)dealloc
{
    [_scrollview release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _scrollview  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollview.pagingEnabled = YES;
    
    [self.view addSubview:_scrollview];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.delegate = self;
    _scrollview.bounces = NO;
    [self addScrollviewContent];
    
    _pagecontroll = [[SMPageControl alloc] initWithFrame:CGRectMake(110, _scrollview.bounds.size.height - 44, 100, 40)];
    _pagecontroll.backgroundColor = [UIColor clearColor];
    _pagecontroll.numberOfPages = 4;
    _pagecontroll.currentPage = 0;
    [_pagecontroll setIndicatorMargin:2];
    [_pagecontroll setIndicatorDiameter:5];
    [_pagecontroll setPageIndicatorImage:[UIImage imageNamed:@"currentPageDot.png"]];
    [_pagecontroll setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageDot.png"]];
    [_pagecontroll setUserInteractionEnabled:NO];
    [self.view addSubview:_pagecontroll];
}
- (void)addScrollviewContent
{
    
    UIImageView * imageView = nil;
    CGFloat height = _scrollview.bounds.size.height;
    CGFloat offset = _scrollview.bounds.size.width;
    for (int i = 0; i < PAGENUM; i++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * offset, 0, offset, height)];
        imageView.image = [UIImage imageNamed:staticImage[i]];
        imageView.tag = i;
        [_scrollview addSubview:imageView];
        [imageView release];
    }
    
    [_scrollview setContentSize:CGSizeMake(offset * PAGENUM, height)];
    imageView = (UIImageView *)[_scrollview viewWithTag:PAGENUM - 1];
    [imageView setUserInteractionEnabled:YES];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn_normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn_press.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"开始使用" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    button.frame = CGRectMake(105, 361, 110, 35);
    [button addTarget:self action:@selector(beginUse:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
}
- (void)beginUse:(id)sender
{
    SCPAppDelegate * delegate = (SCPAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate removeFromWindows];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollview]) {
        NSInteger num = floorf(([_scrollview contentOffset].x+ 161) / _scrollview.bounds.size.width);
        _pagecontroll.currentPage = num;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
