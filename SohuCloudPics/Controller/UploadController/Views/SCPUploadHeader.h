//
//  SCPUploadHeader.h
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCPLabelBox.h"
#import "SCPAlert_Rename.h"
#import "SCPRequestManager.h"
@class AlbumsTableManager;
@class SCPUploadHeader;

@interface FoldersMode : NSObject
@property (nonatomic,retain)NSString * foldrsName;
@property (nonatomic,retain)NSString * folders_Id;
@property (nonatomic,assign)BOOL isPublic;
@end
@protocol UploadHeadDeleagte <NSObject>
- (void)uploadHeader:(SCPUploadHeader *)header selectAlbum:(NSString *)albumID;
@end
@interface SCPUploadHeader : UITableViewCell< SCPAlertRenameViewDelegate,SCPRequestManagerDelegate>
{
    UITableView *_albumsTable;
    AlbumsTableManager *_manager;
    SCPRequestManager * _requestmanager;
    NSMutableArray * _foldersArray;
}
@property (assign, nonatomic) id<UploadHeadDeleagte> delegate;
// data
@property (strong, nonatomic) NSMutableArray *foldersArray;
@property (assign, nonatomic) NSInteger currentAlbum;

// view
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *albumChooseLabel;
@property (strong, nonatomic) UIButton *albumChooseButton;
@property (strong, nonatomic) UILabel * albumNameLabel;
//@property (strong, nonatomic) UITableViewCell * albumName;
@property (strong, nonatomic) UILabel *labelBoxLabel;

- (void)dismissAlbumChooseTable;

@end
