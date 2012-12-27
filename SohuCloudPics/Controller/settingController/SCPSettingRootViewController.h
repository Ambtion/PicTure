//
//  SCPSettingRootViewController.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>

@interface SCPSettingRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    id _controller;
}
- (id)initwithController:(id)controller;
@end
