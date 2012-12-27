//
//  PulingRefreshController.h
//  mmm
//
//  Created by sohu on 12-10-22.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerForHeadView.h"
#import "EGORefreshTableHeaderView.h"

@class PullingRefreshController;
@protocol PullingRefreshDelegate <NSObject, UITableViewDelegate>
@optional
-(void)pullingreloadTableViewDataSource:(id)sender;
-(void)pullingreloadMoreTableViewData:(id)sender;
-(void)pullingreloadPushToTop:(id)sender;

@end


@interface DelegateManager : NSObject <EGORefreshTableHeaderDelegate, UITableViewDelegate>
{
    @package
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshView;
    UITableView* _tableView;
    UIScrollView* _scrollView;
    PullingRefreshController * controller;
    BOOL _shutDown;
    BOOL _loadingMore;
}
@property(nonatomic,assign)id<PullingRefreshDelegate> delegate;
- (void)managerRefreshDoneLoadingTableViewData;
- (void)managerMoreDoneLoadingTableViewData;
- (void)shutChangeFunction;
- (void)openChangeFunction;
@end

@interface PullingRefreshController : UIViewController
{
    UIScrollView* _scrollView;
    BannerForHeadView* _headView;
    
    UITableView* _tableView;
    EGORefreshTableHeaderView * _refreshView;
    
    DelegateManager * _manager;
    id<PullingRefreshDelegate> _delegate;
    UIView * _footView;
    BOOL _shutDown;
}
@property(nonatomic,assign)id<PullingRefreshDelegate> delegate;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)BannerForHeadView * headView;
@property(nonatomic,retain)UIView * footView;
@property(nonatomic,readonly)DelegateManager * manager;
@property(nonatomic,retain)UIButton * topbutton;
- (id)initWithImageName:(UIImage*)image frame:(CGRect )frame;
- (id)initWithLabelName:(NSString *)name frame:(CGRect )frame;
- (void)reloadDataSourceWithAniamtion:(BOOL)animation;

- (void)showLoadingMore;
- (void)realLoadingMore:(id)sender;
- (void)moreDoneLoadingTableViewData;

- (void)refreshDoneLoadingTableViewData;

- (void)shutDataChangeFunction;
- (void)openDataChangeFunction;
- (void)setFootViewoffsetY:(CGFloat)offsetY;
@end
