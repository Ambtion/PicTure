//
//  PhotoDetailManager.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullingRefreshController.h"
#import "FeedCell.h"
#import "FeedDescription.h"
#import "CommentCell.h"
#import "SCPAlert_LoginView.h"
#import "SCPLoginViewController.h"
#import "SCPRequestManager.h"
#import "SCPPhotoListController.h"


@class SCPPhotoDetailViewController;

@interface PhotoDetailManager : NSObject <PullingRefreshDelegate, UITableViewDataSource,BannerDataSoure, FeedCellDelegate, CommentCellDelegate, SCPAlertLoginViewDelegate, SCPLoginViewDelegate,SCPRequestManagerDelegate,SCPPhotoListControllerDeletate,FeedDescriptionDelgate>
{
    NSMutableArray * _dataSourceArray;
    NSDictionary * _infoFromSuper;
    NSString * _photo_ID;
    NSString * _user_ID;
    SCPRequestManager * _requestManger;
    BOOL _isinit;
    BOOL _isLoading;
    BOOL _willRefresh;
    NSInteger numCount;
}

@property (assign, nonatomic) SCPPhotoDetailViewController *controller;
@property (retain, nonatomic) NSDictionary * infoFromSuper;
@property (nonatomic, retain) NSString * photo_ID;
@property (nonatomic, retain)SCPPhotoListController * listView;
- (id)initWithController:(SCPPhotoDetailViewController *)ctrl info:(NSDictionary*)info;
- (id)initWithController:(SCPPhotoDetailViewController *)ctrl useId:(NSString*) useId photoId:(NSString*)photoId;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
@end
