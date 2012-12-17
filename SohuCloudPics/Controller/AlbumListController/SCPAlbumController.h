//
//  SCPAlbumController.h
//  SohuCloudPics
//
//  Created by Chen Chong on 12-11-14.
//
//

#import <UIKit/UIKit.h>

#import "SCPSecondLayerController.h"
#import "SCPAlbumCell.h"
#import "PullingRefreshController.h"
#import "SCPAlert_LoginView.h"
#import "SCPRequestManager.h"

#import "SCPUploadTaskManager.h"

typedef enum {
    SCPAlbumControllerStateNormal = 0,
    SCPAlbumControllerStateDelete = 1,
} SCPAlbumControllerState;

@interface SCPAlbumController : SCPSecondLayerController <PullingRefreshDelegate, BannerDataSoure, UITableViewDataSource, SCPAlbumCellDelegate, SCPAlertLoginViewDelegate, SCPRequestManagerDelegate>
{
    SCPAlbumControllerState _state;
    
    UIButton *_backButton;
    
    UIView *_rightBarView;
    UIButton *_switchButton;
    UIButton *_uploadButton;
    UIButton *_okButton;
	
	SCPRequestManager *_request;
	
	BOOL _hasNextPage;
	int _currentPage;
	int _loadedPage;
}

/* Data */
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSMutableArray *albumList;
@property (strong, nonatomic) NSString *bannerLeftString;
@property (strong, nonatomic) NSString *bannerRightString;
@property (nonatomic,retain ) UIProgressView * curProgreeeView;

/* UI */
@property (strong, nonatomic) PullingRefreshController *pullingController;

/* for subclass */
- (UIButton *)switchButtonView;
- (SCPAlbumController *)switchController;

- (void)loadNextPage;
- (void)refresh;
@end
