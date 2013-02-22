//
//  ELCAlbumPickerViewController.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-22.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DeleteController.h"

@interface ELCAlbumPickerViewController : UIViewController<UIAlertViewDelegate,
    UITableViewDelegate,UITableViewDataSource> {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
    ALAssetsLibrary *library;
    BOOL _isReading;
}
@property (strong,nonatomic) UITableView * mytableView;
@property (strong,nonatomic) DeleteController *delController;
@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic,retain ) ALAssetsLibrary * library;
-(void)selectedAssets:(NSArray*)_assets;
@end
