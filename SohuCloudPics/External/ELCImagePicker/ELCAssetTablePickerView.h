//
//  ELCAssetTablePickerView.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-26.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DeleteController.h"

@interface ELCAssetTablePickerView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	ALAssetsGroup *assetGroup;
	NSMutableArray *elcAssets;
	int selectedAssets;
	id parent;
	NSOperationQueue *queue;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DeleteController *delController;
@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;

-(int)totalSelectedAssets;
-(void)preparePhotos;
-(void)doneAction:(id)sender;

@end
