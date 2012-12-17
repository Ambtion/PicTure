//
//  PullingRefreshTableView.m
//  TableTry
//
//  Created by Zhong Sheng on 12-9-4.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "PullingRefreshTableView.h"

#define DEFAULT_ARROW (@"arrow.png")
#define DEFAULT_COLOR ([UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0])

#pragma mark - EGOManager
@interface EGOManager : NSObject <EGORefreshTableHeaderDelegate, UITableViewDelegate>
{
@package
    BOOL _reloading;
    EGORefreshTableHeaderView *_headerView;
    PullingRefreshTableView *_tableView;
}
@end

@implementation EGOManager

- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    
    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
}

#pragma mark EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
//    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
#pragma mark Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [_tableView.pDelegate scrollViewDidScroll:scrollView];
    
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [_tableView.pDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [_tableView.pDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_tableView.pDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [_tableView.pDelegate scrollViewShouldScrollToTop:scrollView];

    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [_tableView.pDelegate scrollViewDidScrollToTop:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_tableView.pDelegate scrollViewWillBeginDecelerating:scrollView];
    
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_tableView.pDelegate scrollViewDidEndDecelerating:scrollView];
}


#pragma mark Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [_tableView.pDelegate viewForZoomingInScrollView:scrollView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [_tableView.pDelegate scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [_tableView.pDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [_tableView.pDelegate scrollViewDidZoom:scrollView];
}


#pragma mark Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_tableView.pDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - UITableViewDelegate
#pragma mark Configuring Rows for the Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Managing Accessory Views
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_tableView.pDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)])
//        return [_tableView.pDelegate tableView:tableView accessoryTypeForRowWithIndexPath:indexPath];
//    
//    return UITableViewCellAccessoryNone;
//}

#pragma mark Managing Selections
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

#pragma mark Modifying the Header and Footer of Sections
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [_tableView.pDelegate tableView:tableView viewForHeaderInSection:section];
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [_tableView.pDelegate tableView:tableView viewForFooterInSection:section];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [_tableView.pDelegate tableView:tableView heightForHeaderInSection:section];
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        return [_tableView.pDelegate tableView:tableView heightForFooterInSection:section];
    
    return 0.0;
}

#pragma mark Editing Table Rows
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];

    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

#pragma mark Reordering Table Rows
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [_tableView.pDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return nil;
}

#pragma mark Copying and Pasting Row Content
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
        return [_tableView.pDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
        [_tableView.pDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}

@end


#pragma mark - 
#pragma mark PullingRefreshTableView
@implementation PullingRefreshTableView

//@synthesize delegate = _p_delegate;
@synthesize pDelegate = _pDelegate;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:arrow textColor:textColor];

        _egoManager = [[EGOManager alloc] init];
        _egoManager->_headerView = _headerView;
        _egoManager->_tableView = self;
        
        [super setDelegate:_egoManager];
        [_headerView setDelegate:_egoManager];
        [self addSubview:_headerView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame arrowImageName:DEFAULT_ARROW textColor:DEFAULT_COLOR style:style];
}


- (void)dealloc
{
    [_headerView release];
    [_egoManager release];
    [super dealloc];
}


@end
