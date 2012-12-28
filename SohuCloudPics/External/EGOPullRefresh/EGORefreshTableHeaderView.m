//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18

#define OFFSET_Y 0
@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end


@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isWillRefresh = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 30.0 + OFFSET_Y, self.frame.size.width, 20.0)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0];
		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:1 alpha:1.0];
//		label.shadowOffset = CGSizeMake(0.0, 1.0);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel = label;
		[label release];
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 48.0 + OFFSET_Y, self.frame.size.width, 20.0)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.f];
		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:1 alpha:1.0];
//		label.shadowOffset = CGSizeMake(0.0, 1.0);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel = label;
		[label release];
		
        //图片层
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0 + 50, frame.size.height - 65.0 + 10 + OFFSET_Y, 30.0, 55.0);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage = layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0 + 50, frame.size.height - 38.0 + 10 - 2 + OFFSET_Y - 5, 20.0, 20.0);
		[self addSubview:view];
		_activityView = view;
		[view release];
		[self setState:EGOOPullRefreshNormal];
    }	
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
    
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
        
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"MM-dd H:mm"];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新:%@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
	} else {
		_lastUpdatedLabel.text = @"精彩立即呈现";
	}
}

- (void)setState:(EGOPullRefreshState)aState
{
	switch (aState) {
		case EGOOPullRefreshPulling:    // Pulling
            _statusLabel.text = @"释放立即刷新";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0, 0.0, 0.0, 1.0);
			[CATransaction commit];
			break;
            
		case EGOOPullRefreshNormal:     // Normal
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
            _statusLabel.text = @"下拉刷新";

			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			[self refreshLastUpdatedDate];
			break;
            
		case EGOOPullRefreshLoading:
            // Loading
            _statusLabel.text = @"正在获取新内容";

			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
            
		default:
			break;
	}
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -65 && isWillRefresh) {
        isWillRefresh = NO;
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
      	[UIView setAnimationDuration:0.2];
       	scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
     	[UIView commitAnimations];
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
    }
	if (_state == EGOOPullRefreshLoading) {
        // 当下拉松开刷新时，scrollViewDidScroll会进入这里，为了不让scrollView直接收回到顶，这里用了一个offset
		CGFloat offset = MAX(scrollView.contentOffset.y * -1,0);
		offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0);

	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        if (!_loading) {
            float y = scrollView.contentOffset.y;
            switch (_state) {
                case EGOOPullRefreshPulling:
                    if (y > -65.0 && y < 0) { // 这一区间总是设置状态为Normal
                        [self setState:EGOOPullRefreshNormal];
                    }
                    break;
                case EGOOPullRefreshNormal:
                    if (y <= -65.0) { // 超出区间之后，设置状态为Pulling
                        [self setState:EGOOPullRefreshPulling];
                    }
                    break;
                default:    // never reach here
                    break;
            }       
        }
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
//		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
//			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
//		}
		isWillRefresh = YES;
//        [self setState:EGOOPullRefreshLoading];
//
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.2];
//		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
//		[UIView commitAnimations];

	}

}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
    [self setState:EGOOPullRefreshNormal];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
    
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end
