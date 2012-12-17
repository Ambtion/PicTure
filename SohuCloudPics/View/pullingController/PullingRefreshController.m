//
//  PulingRefreshController.m
//  
//
//  Created by Qu on 12-10-22.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import "PullingRefreshController.h"





@implementation DelegateManager
@synthesize delegate = _delegate;


#pragma mark -shutDown
- (void)shutChangeFunction
{
    _shutDown = YES;
}
- (void)openChangeFunction
{
    _shutDown = NO;

}
- (void)reloadTableViewDataSource
{
    _reloading = YES;
    if ([self.delegate respondsToSelector:@selector(pullingreloadTableViewDataSource:)]) {
        [self.delegate pullingreloadTableViewDataSource:_refreshView];
    }
}

- (void)managerRefreshDoneLoadingTableViewData
{
    _reloading = NO;
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
}

- (void)managerMoreDoneLoadingTableViewData
{
    _reloading = NO;
    UIView *  view = controller.tableView.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    label.text  = @"加载更多...";
    UIActivityIndicatorView * act = (UIActivityIndicatorView *)[view viewWithTag:200];
    [act stopAnimating];
}

#pragma mark EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height ) {
        _tableView.frame = CGRectMake(0, 0, 320, controller.view.bounds.size.height);
    }else{
        _tableView.frame = CGRectMake(0, 0, 320, controller.view.bounds.size.height + 44);
    }
    
    [self updateContentOffset];
    
    if (scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.frame.size.height || scrollView.contentSize.height <= scrollView.frame.size.height) {
        if (_loadingMore) {
            _loadingMore = NO;
           [controller realLoadingMore:nil];
        }
    }
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];

    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:scrollView];
    }
}
#pragma mark  CustomeScrollview
- (void)updateContentOffset {
    
    CGFloat offsetY = _tableView.contentOffset.y;
    
    if (offsetY < 0) {
        offsetY = 0;
    }
    _scrollView.contentOffset = CGPointMake(0.0f, offsetY);
    return;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{   
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_shutDown)
        return;
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 44 && scrollView.contentOffset.y >= 44 && !controller.footView.hidden) {
        [controller showLoadingMore];
        _loadingMore = YES;
    }
    [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:scrollView];
}


#pragma mark Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:scrollView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:scrollView];
}


#pragma mark Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - UITableViewDelegate
#pragma mark Configuring Rows for the Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Managing Accessory Views
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}


#pragma mark Managing Selections
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

#pragma mark Modifying the Header and Footer of Sections
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    
    return 0.0;
}

#pragma mark Editing Table Rows
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

#pragma mark Reordering Table Rows
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return nil;
}

#pragma mark Copying and Pasting Row Content
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}

@end


@implementation PullingRefreshController
@synthesize tableView = _tableView;
@synthesize headView = _headView;
@synthesize footView = _footView;
@synthesize manager = _manager;
@synthesize scrollView = _scrollView;
- (void)dealloc
{
    [_scrollView release];
    [_headView release];
    [_tableView release];
    [_refreshView release];
    [_manager release];
    self.footView = nil;
    [super dealloc];

}
-(id)initWithImageName:(UIImage*)image frame:(CGRect )frame
{
    self = [super init];
    if (self) {
        _shutDown = NO;
        self.view.frame = frame;
        _headView = [[BannerForHeadView alloc] initWithImageName:image];
        [self addsubviews];
    }
    return self;
}
- (id)initWithLabelName:(NSString *)name frame:(CGRect )frame
{
    self = [super init];
    if (self) {
        _shutDown = NO;
        self.view.frame = frame;
        _headView = [[BannerForHeadView alloc] initWithLabelName:name];
        [self addsubviews];
        
    }
    return self;
}

- (void)addsubviews
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [_scrollView setContentSize:CGSizeMake(320, 1000)];
    [_scrollView setUserInteractionEnabled:NO];
    [_scrollView addSubview:_headView];

    _scrollView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, 320, self.view.bounds.size.height );
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    _tableView.separatorColor = [UIColor clearColor];
    
    UIView * headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    headView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    _tableView.tableHeaderView = headView;
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 40, 320, 60) arrowImageName:@"dorp_down.png" textColor:[UIColor colorWithRed:98/255.f green:98/255.f blue:98/255.f alpha:1]];
    [_tableView.tableHeaderView addSubview:_refreshView];
//    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [self.view addSubview:_scrollView];

    
    _manager = [[DelegateManager alloc] init];
    _manager->_reloading = NO;
    _manager->controller = self;
    _manager->_loadingMore = NO;
    _tableView.delegate = _manager;
    _manager->_tableView = _tableView;
    _manager->_refreshView = _refreshView;
    _manager->_scrollView = _scrollView;
    _refreshView.delegate = _manager;
    
    [self addTableFootView];
}
- (void)addTableFootView
{
    
//    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] ;
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] ;
    _footView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(realLoadingMore:)] autorelease];
    [_footView addGestureRecognizer:gesture];
    UIImageView * imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(110, 21, 18, 18)] autorelease];
    imageview.image = [UIImage imageNamed:@"load_more_pics.png"];
    [_footView addSubview:imageview];
    
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(66  + 10, 0, 320 - 142, 60)] autorelease];
    label.tag = 100;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:97.0/255 green:120.0/255 blue:137.0/255 alpha:1];
    label.text = @"加载更多...";
    label.backgroundColor = [UIColor clearColor];
    [_footView addSubview:label];
    
    UIActivityIndicatorView * active = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    active.tag = 200;
    active.frame = CGRectMake(320 - 66 + 22,30, 0, 0);
    active.color = [UIColor blackColor];
    active.hidesWhenStopped = YES;
    [active stopAnimating];
    [_footView addSubview:active];
    UIImageView * bg_imageview = [[[UIImageView alloc] initWithFrame:CGRectMake((320 - 30)/2.f,15.f, 30.f, 30.f)]autorelease];
    bg_imageview.image =[UIImage imageNamed:@"end_bg.png"];
    UIView * view = [[[UIView alloc] initWithFrame:_footView.bounds] autorelease];
    view.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    [view addSubview:bg_imageview];
    [view addSubview:_footView];
    _tableView.tableFooterView = view;
//    self.footView.hidden = YES;
}
- (void)setFootViewoffsetY:(CGFloat)offsetY
{
    for (UIView * view in _tableView.tableFooterView.subviews) {
        CGRect rect = view.frame;
        rect.origin.y += offsetY;
        view.frame = rect;
    }
}
- (void)shutDataChangeFunction
{
    _shutDown = YES;
    [self.manager shutChangeFunction];
}
- (void)openDataChangeFunction
{
    _shutDown = NO;
    [self.manager openChangeFunction];
}
#pragma mark refresh

#pragma mark loadingMore
- (void)showLoadingMore
{
    if (_shutDown) {
        return;
    }
    if (_manager->_reloading) {
        return;
    }
    _manager->_reloading = YES;
    UIView * view  = _tableView.tableFooterView;
    UILabel * label = (UILabel *)[view viewWithTag:100];
    UIActivityIndicatorView * acv  = (UIActivityIndicatorView *)[view viewWithTag:200];
    label.text = @"加载中...";
    [acv startAnimating];
}
- (void)realLoadingMore:(id)sender
{
    if (sender) {
        [self showLoadingMore];
    }
    if ([_delegate respondsToSelector:@selector(pullingreloadMoreTableViewData:)]) {
        [_delegate pullingreloadMoreTableViewData:self];
    }
}
- (id<PullingRefreshDelegate>)delegate
{
    return _delegate;
}

- (void)setDelegate:(id<PullingRefreshDelegate>)delegate
{
    _delegate = delegate;
    _manager.delegate = _delegate;
}
- (void)reloadDataSourceWithAniamtion:(BOOL)animation
{    
    if (animation) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [_tableView reloadData];
    }
    [_headView BannerreloadDataSource];
}
#pragma mark - loadingfinished
- (void)refreshDoneLoadingTableViewData
{
    [_manager managerRefreshDoneLoadingTableViewData];
}
- (void)moreDoneLoadingTableViewData
{
    [_manager managerMoreDoneLoadingTableViewData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark -
#pragma mark delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
