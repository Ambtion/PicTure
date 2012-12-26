//
//  SCPPhotoGridController.h
//  SohuCloudPics
//
//  Created by Yingxue Peng on 12-9-24.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import "SCPSecondLayerController.h"
#import "SCPAlbum.h"
#import "PullingRefreshController.h"
#import "SCPPhotoGridCell.h"
#import "SCPRequestManager.h"

#import "SCPAlert_DeletView.h"
#import "SCPAlert_Rename.h"
#import "SCPAlert_DetailView.h"
#import "SCPUploadTaskManager.h"

typedef enum {
    PhotoGridStateNormal = 0,
    PhotoGridStateDelete = 1,
} PhotoGridState;


@interface SCPPhotoGridController : SCPSecondLayerController <PullingRefreshDelegate, BannerDataSoure, UITableViewDataSource, SCPPhotoGridCellDelegate, SCPRequestManagerDelegate,SCPAlertDeletViewDelegate,SCPAlertRenameViewDelegate,SCPAlert_DetailViewDelegate,UIAlertViewDelegate>
{
    PhotoGridState _state;
    NSMutableSet *_tasksToDel;
    NSMutableSet *_imagesToDel;
    
    UIButton *_backButton;
    
    UIView *_rightBarView;
    
    UIButton *_iMarkButton;
    UIButton *_trashButton;
    UIButton *_penButton;
    UIButton *_okButton;
    UIButton *_cancelButton;
	
	SCPRequestManager *_request;
    NSInteger taskTotal;
    BOOL hasNextPage;
    NSInteger curpage;
    BOOL isLoading;
}

/* Data */
@property (strong, nonatomic) SCPAlbum *albumData;
@property (strong, nonatomic) NSMutableArray *photoList;
@property (strong, nonatomic) SCPAlbumTaskList *uploadTaskList; //下载的任务列 SCPTaskUnit
@property (strong, nonatomic) NSMutableArray * thumbnailArray;

@property (strong, nonatomic) NSString *bannerLeftString;
@property (strong, nonatomic) NSString *bannerRightString;
/* UI */
@property (strong, nonatomic) PullingRefreshController *pullingController;
- (void)refresh;
@end
