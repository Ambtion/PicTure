//
//  SCPSettingUserinfoController.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"

@interface SCPSettingUserinfoController : UIViewController
{
    SCPRequestManager * _request;
    UIImageView * _portraitView;
    UITextField * _nameFiled;
    UITextField * _description;
}
@end
