//
//  SCPFirstIntroController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPFirstIntroController.h"
#import "SCPMainTabController.h"

@interface SCPFirstIntroController ()

@end

@implementation SCPFirstIntroController
@synthesize parent;
@synthesize scrollView;
@synthesize pageControl;

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
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self initScrollView];
    [self.view addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    pageControl.center = CGPointMake(160, 440);
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    [self.view bringSubviewToFront:pageControl];
    
	// Do any additional setup after loading the view.
}
-(void)initScrollView{
    kNumberOfPages = 3;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Go!" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 120, 40);
    btn.center = CGPointMake(800, 300);
    [btn addTarget:self action:@selector(onGoClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pageControl = nil;
    self.scrollView = nil;
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
-(void)dealloc{
    self.parent = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    [super dealloc];
}
#pragma mark -
#pragma btnClick
-(void)onGoClick:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:NO];
    }else {
        [[self parentViewController] dismissModalViewControllerAnimated:NO];
    }
}

#pragma mark -
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
