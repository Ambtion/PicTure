//
//  PhotoTableManager.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "ExploreTableManager.h"

#import "SCPExplorerController.h"
#import "SCPPhotoDetailViewController.h"
#import "SCPAlert_CustomeView.h"

#define MAXPICTURE 400

@implementation NSMutableArray (AddWithType_and_Random)

- (void)addRect:(CGRect)rect
{
    [self addObject:[NSValue valueWithCGRect:rect]];
}

@end

static CGFloat strategy1(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 200)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    [frames addRect:CGRectMake(5, 205, 205, 100)];
    
    [frames addRect:CGRectMake(215, 105, 100, 200)];
    
    return 310;
}

static CGFloat strategy2(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(5, 105, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 205, 205)];
    
    return 210;
}

static CGFloat strategy3(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 205)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    [frames addRect:CGRectMake(215, 105, 100, 100)];
    
    return 210;
}

static CGFloat strategy4(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 205)];
    
    [frames addRect:CGRectMake(110, 0, 205, 205)];
    
    return 210;
}

static CGFloat strategy5(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 205, 100)];
    
    return 105;
}

static CGFloat strategy6(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 100, 100)];
    
    [frames addRect:CGRectMake(110, 0, 100, 100)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    return 105;
    
}

static CGFloat strategy7(NSMutableArray *frames, NSMutableArray *figures)
{
    [frames addRect:CGRectMake(5, 0, 205, 105)];
    
    [frames addRect:CGRectMake(215, 0, 100, 105)];
    
    return 110;
}

static CGFloat (*strategys[])(NSMutableArray *, NSMutableArray *) = {
    strategy1, strategy2, strategy3, strategy4,
    strategy5, strategy6, strategy7
};


static NSInteger lastNum = -1;

@implementation ExploreTableManager

@synthesize controller = _controller;
@synthesize isLoading = _isLoading;
- (NSInteger)randomNum
{
    int i;
    while ((i = (random() >> 16) % 6) == lastNum) {
        // empty
    }
    lastNum = i;
    return lastNum;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requestManager setDelegate:nil];
    [_requestManager release];
    [_strategyArray release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _strategyArray = [[NSMutableArray alloc] init];
        _requestManager = [[SCPRequestManager alloc] init];
        //        _requestManager.delegate = self;
        _isLoading = NO;
        _willRefresh = YES;
        _isinit = YES;
        _lastCount = 0;
    }
    return self;
}

- (NSArray *)urlArray:(NSArray *)frames info:(NSArray *)info
{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < frames.count; i++) {
        NSDictionary * dic = [info objectAtIndex:[self offsetOfDataSouce] - _lastCount + i];
        [array addObject:dic];
    }
    return array;
}

- (NSUInteger)offsetOfDataSouce
{
    
    if (!_strategyArray.count) {
        return 0;
    }
    long long i = 0;
    for (ExploreViewCellDataSource * data in _strategyArray) {
        i = i + data.viewRectFrame.count;
    }
    return i;
}

- (NSArray *)getImageViewFrameWithInfoArray:(NSArray *)infoArray : (NSArray *) viewFrame
{
    //需要c_*配合显示
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < viewFrame.count; i++) {
        
        CGRect superRect = [[viewFrame objectAtIndex:i] CGRectValue];
        
        NSDictionary * dic = [infoArray objectAtIndex:i];
        CGFloat heigth = 205;
        CGFloat wigth = 205;
        
        if (!dic ||!heigth || !wigth) {
            [array addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, superRect.size.width, superRect.size.height)]];
            break;
        }
        CGFloat scale = MIN(heigth/superRect.size.height, wigth/superRect.size.width);
        CGRect frame = CGRectMake(0, 0, wigth/scale, heigth/scale);
        frame.origin.x = (superRect.size.width - frame.size.width)/2.f;
        frame.origin.y = (superRect.size.height - frame.size.height)/2.f;
        [array addObject:[NSValue valueWithCGRect:frame]];
        
    }
    return array;
}

#pragma mark -
- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(isRefresh || !_strategyArray.count){
        _lastCount = 0;
        [self getExploreFrom:0 count:80];
    }else{
        if ((MAXPICTURE <= [self offsetOfDataSouce] || ![self offsetOfDataSouce]) && !_isinit) {
            _isLoading = NO;
            [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
            return;
        }
        [self getExploreFrom:[self offsetOfDataSouce] count:80];
    }
}

- (void)getExploreFrom:(NSInteger)startIndex count:(NSInteger)count
{
    [_requestManager getExploreFrom:startIndex maxresult:count sucess:^(NSArray * infoArray) {
        if (startIndex == 0)
            [_strategyArray removeAllObjects];
        for (int i = 0; i < infoArray.count / 4 ; i++) {
            ExploreViewCellDataSource * dataSouce = [[ExploreViewCellDataSource alloc] init];
            NSInteger num_strategy = [self randomNum];
            NSMutableArray * frames = [[NSMutableArray alloc] init];
            dataSouce.heigth = strategys[num_strategy](frames,nil);
            dataSouce.viewRectFrame = frames;
            dataSouce.infoArray = [self urlArray:frames info:infoArray];
            dataSouce.imageFrame =[self getImageViewFrameWithInfoArray:dataSouce.infoArray :frames];
            dataSouce.identify = [NSString stringWithFormat:@"startegy%d", num_strategy];
            [_strategyArray addObject:dataSouce];
            [frames release];
            [dataSouce release];
        }
        _lastCount = [self offsetOfDataSouce];
        if (_isinit) {
            _isinit = NO;
            _isLoading = NO;
            [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
            [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
            [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
            return ;
        }
        if (startIndex == 0 ) {
            [self refreshDataFinishLoad];
        }else{
            [self moreDataFinishLoad];
        }
    } failture:^(NSString *error) {
        SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
        [alertView show];
        [self restNetWorkState];
    }];
}
- (void)restNetWorkState
{
    if (_willRefresh) {
        [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    }else{
        [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    }
    _willRefresh = YES;
    _isLoading = NO;
}
#pragma mark - Top
- (void)pullingreloadPushToTop:(id)sender
{
    [self.controller showNavigationBar];
}
#pragma mark refresh
//1:下拉刷新 2:刷新结束

- (void)refreshData:(id)sender
{
    if (_isLoading)  return;
    [self dataSourcewithRefresh:YES];
}
- (void)pullingreloadTableViewDataSource:(id)sender
{
    SCPBaseNavigationItem * item = self.controller.item;
    [item.refreshButton rotateButton];
    [self refreshData:nil];
}
- (void)refreshDataFinishLoad
{
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    _isLoading = NO;
}
//更多
#pragma mark more
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self dataSourcewithRefresh:NO];
}
- (void)moreDataFinishLoad
{
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
    _isLoading = NO;
}

#pragma mark -
#pragma mark bannerDatasouce

- (NSString*)bannerDataSouceLeftLabel
{
    return [NSString stringWithFormat:@"有%d张图片",[self offsetOfDataSouce]];
}
- (NSString*)bannerDataSouceRightLabel
{
    //    return [self.controller getTimeString];
    return nil;
}

#pragma mark -
#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((MAXPICTURE <= [self offsetOfDataSouce] || ![self offsetOfDataSouce]) && !_isinit) {
        [self.controller.pullingController.footView setHidden:YES];
    }else{
        [self.controller.pullingController.footView setHidden:NO];
    }
    return _strategyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreViewCellDataSource * dataSource = [_strategyArray objectAtIndex:indexPath.row];
    return dataSource.heigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExploreViewCellDataSource * dataSource = [_strategyArray objectAtIndex:indexPath.row];
    ExploreViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataSource.identify];
    if (cell == nil) {
        cell = [[[ExploreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dataSource.identify andframe:dataSource.viewRectFrame height:dataSource.heigth] autorelease];
        cell.delegate = self;
    }
    cell.dataSource = dataSource;
    if (_strategyArray.count - 1 == indexPath.row )
        [self.controller.pullingController realLoadingMore:nil];
    return cell;
}

#pragma mark -
#pragma mark imageView Method
- (void)exploreCell:(ExploreViewCell *)cell imageClick:(UIImageView *)imageView
{
    SCPPhotoDetailViewController * pho_detail = [[[SCPPhotoDetailViewController alloc] initWithinfo:[cell.dataSource.infoArray objectAtIndex:imageView.tag]] autorelease];
    SCPExplorerController *exp = (SCPExplorerController *)_controller;
    [exp.navigationController pushViewController:pho_detail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
}

@end
