//
//  SCPUploadController.h
//  SohuCloudPics
//
//  Created by mysohu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPSecondLayerController.h"
#import "SCPUploadHeader.h"
#import "SCPAlbum.h"
#import "SCPRequestManager.h"

@interface SCPUploadController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate, UITextViewDelegate, UIActionSheetDelegate, SCPLabelBoxDelegate, SCPLabelChooserDelegate, SCPRequestManagerDelegate,UploadHeadDeleagte>
{
    BOOL _displayingLabels;
    SCPRequestManager * _requsetManager;
    
    NSMutableArray *_preLabelObjs;
    NSArray *_imageList;
    NSArray *_cells;
    id controller;
}

@property (assign, nonatomic) CGFloat keyboardHeight;

// data
//@property (strong, nonatomic) NSMutableArray * labelList;
@property (strong, nonatomic) NSString * curAlbumID;
@property (strong, nonatomic) NSMutableArray * albumList;
//@property (strong, nonatomic) SCPAlbum *uploadAlbum;

// view
@property (strong, nonatomic) UITableView *uploadTableView;
@property (strong, nonatomic) SCPUploadHeader *uploadHeader;    // row 0
@property (strong, nonatomic) SCPLabelBox *labelBox;            // row 1
@property (strong, nonatomic) UITableViewCell *labelChooser;    // row 2
@property (strong, nonatomic) UITableViewCell *descCell;        // row 3

// init
- (id)initWithImageToUpload:(NSArray *)imageList : (id)decontrller;

// upload

@end
