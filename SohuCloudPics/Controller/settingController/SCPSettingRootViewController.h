//
//  SCPSettingRootViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "SCPAlertView_LoginTip.h"

@interface SCPSettingRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    id _controller;
    SCPAlertView_LoginTip * loginView;
    SCPAlertView_LoginTip * cacheView;
    SCPAlertView_LoginTip * updataView;
}
- (id)initwithController:(id)controller;
@end
