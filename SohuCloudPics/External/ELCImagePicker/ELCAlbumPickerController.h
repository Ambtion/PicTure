//
//  AlbumPickerController.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DeleteController.h"

@interface ELCAlbumPickerController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource> {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
    ALAssetsLibrary *library;
    BOOL _isReading;
}
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) DeleteController *delController;
@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic,retain ) ALAssetsLibrary * library;
-(void)selectedAssets:(NSArray*)_assets;
@end

