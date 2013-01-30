//
//  SCPMyHomeViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "MyHomeManager.h"
#import "SCPSecondLayerController.h"
#import "SCPBaseNavigationItem.h"

@interface SCPMyHomeController : SCPSecondLayerController
{
    UIView *_footView;
}
@property (strong, nonatomic) MyHomeManager *manager;
@property (strong, nonatomic) UITableView *homeTable;
@property (strong, nonatomic) UIButton * topButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useID:(NSString *) use_ID;
@property (strong, nonatomic) UIView * footView;
@end
