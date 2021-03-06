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
#import "SCPAlert_LoginView.h"
#import "SCPLoginViewController.h"
#import "SCPRequestManager.h"
#import "SCPPhotoListController.h"

@class SCPPhotoDetailController;

@interface PhotoDetailManager : NSObject <PullingRefreshDelegate, UITableViewDataSource,BannerDataSoure, FeedCellDelegate, SCPAlertLoginViewDelegate, SCPLoginViewDelegate,SCPRequestManagerDelegate,SCPPhotoListControllerDeletate,FeedDescriptionDelgate>
{
    NSMutableArray * _dataSourceArray;
    NSDictionary * _imageInfo;
    NSString * _photo_ID;
    NSString * _user_ID;
    SCPRequestManager * _requestManger;
    BOOL _isinit;
    BOOL _isLoading;
    BOOL _isRefeshing;
    NSInteger numCount;
}

@property (assign, nonatomic) SCPPhotoDetailController *controller;
@property (retain, nonatomic) NSDictionary * imageInfo;
@property (nonatomic, retain) NSString * photo_ID;
@property (nonatomic, retain)SCPPhotoListController * listView;

- (id)initWithController:(SCPPhotoDetailController *)ctrl UserId:(NSString*) userId PhotoId:(NSString*)photoId;
- (void)dataSourcewithRefresh:(BOOL)isRefresh;
@end
