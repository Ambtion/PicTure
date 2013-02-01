//
//  PhotoTableManager.m
//  sohu_yuntu
//
//  Created by Zhong Sheng on 12-8-21.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "PlazeManager.h"

#import "SCPPlazeController.h"
#import "SCPPhotoDetailController.h"
#import "SCPAlert_CustomeView.h"
#import "PlazeDataAdapter.h"

#define MAXPICTURE 200
#define PICTURECOUNT 20 * MAXFRAMECOUNTLIMIT

@implementation PlazeManager

@synthesize controller = _controller;
@synthesize isLoading = _isLoading;

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
        _isLoading = NO;
        _willRefresh = YES;
        _isinit = YES;
        _startoffset = 0;
    }
    return self;
}

#pragma mark -

- (void)dataSourcewithRefresh:(BOOL)isRefresh
{
    _isLoading = YES;
    _willRefresh = isRefresh;
    if(isRefresh || !_strategyArray.count){
        _startoffset = 0;
        [self getPlazeFrom:0 count:PICTURECOUNT];
    }else{
        if((MAXPICTURE <= [self offsetOfDataSouce] || ![self offsetOfDataSouce]) && !_isinit) {
            _isLoading = NO;
            [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
            return;
        }
        _startoffset += PICTURECOUNT;
        [self getPlazeFrom:_startoffset count:PICTURECOUNT];
    }
}
- (PlazeViewCellDataSource *)getSourceWithinfoArray:(NSArray *)infoArray  andIndex:(NSInteger)index
{
    PlazeViewCellDataSource * dataSouce = [[[PlazeViewCellDataSource alloc] init] autorelease];
    NSDictionary * dic = [PlazeDataAdapter getViewFrameForRandom];
    NSArray * frames = [dic objectForKey:@"viewFrame"];
    dataSouce.viewRectFrame = frames;
    dataSouce.higth = [[dic objectForKey:@"height"] floatValue];
    dataSouce.infoArray = [PlazeDataAdapter getURLArrayByImageFrames:frames FrominfoSource:[infoArray subarrayWithRange:(NSRange ){index * MAXFRAMECOUNTLIMIT,MAXFRAMECOUNTLIMIT}]];
    dataSouce.imageFrame = [PlazeDataAdapter getBorderViewOfImageViewByImageViewFrame:frames];
    dataSouce.identify = [NSString stringWithFormat:@"startegy%d", [[dic objectForKey:@"strategy_num"] integerValue]];
    return dataSouce;
}
- (void)getPlazeFrom:(NSInteger)startIndex count:(NSInteger)count
{
    
    [_requestManager getPlazeFrom:startIndex maxresult:count sucess:^(NSArray * infoArray) {
        if (startIndex == 0)
            [_strategyArray removeAllObjects];
        
        for (int i = 0; i < infoArray.count / MAXFRAMECOUNTLIMIT; i++)
            [_strategyArray addObject:[self getSourceWithinfoArray:infoArray andIndex:i]];
        if (_isinit) {
            [self initRefresh];
            return ;
        }
        if (startIndex == 0) {
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
- (void)initRefresh
{
    _isinit = NO;
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
    
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
#pragma mark -
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
    SCPBaseNavigationItemView * item = self.controller.item;
    [item.refreshButton rotateButton];
    [self refreshData:nil];
}
- (void)refreshDataFinishLoad
{
    [(PullingRefreshController *)_controller.pullingController refreshDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:YES];
    _isLoading = NO;
}

#pragma mark more
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self dataSourcewithRefresh:NO];
}
- (void)moreDataFinishLoad
{
    _isLoading = NO;
    [(PullingRefreshController *)_controller.pullingController moreDoneLoadingTableViewData];
    [self.controller.pullingController reloadDataSourceWithAniamtion:NO];
}

#pragma mark -
#pragma mark bannerDatasouce

- (NSUInteger)offsetOfDataSouce
{
    if (!_strategyArray.count)  return 0;
    long long i = 0;
    for (PlazeViewCellDataSource * data in _strategyArray) {
        i = i + data.viewRectFrame.count;
    }
    return i;
}
- (NSString*)bannerDataSouceLeftLabel
{
    return [NSString stringWithFormat:@"有%d张图片",[self offsetOfDataSouce]];
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
    PlazeViewCellDataSource * dataSource = [_strategyArray objectAtIndex:indexPath.row];
    return dataSource.higth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlazeViewCellDataSource * dataSource = nil;
    if (_strategyArray.count > indexPath.row)
        dataSource = [_strategyArray objectAtIndex:indexPath.row];
    PlazeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataSource.identify];
    if (cell == nil) {
        cell = [[[PlazeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dataSource.identify andframe:dataSource.viewRectFrame height:dataSource.higth] autorelease];
        cell.delegate = self;
    }
    cell.dataSource = dataSource;
    if (_strategyArray.count - 1 == indexPath.row )
        [self.controller.pullingController realLoadingMore:nil];
    return cell;
}

#pragma mark -
#pragma mark Action 

- (void)PlazeViewCell:(PlazeViewCell *)cell imageClick:(UIImageView *)imageView
{
    NSDictionary * dic = [cell.dataSource.infoArray objectAtIndex:imageView.tag];
    SCPPhotoDetailController * pho_detail = [[[SCPPhotoDetailController alloc] initWithuseId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]] photoId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_id"]] ] autorelease];
    SCPPlazeController *exp = (SCPPlazeController *)_controller;
    [exp.navigationController pushViewController:pho_detail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
}

@end
