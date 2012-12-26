//
//  SCPSettingUserinfoController.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"

@interface SCPSettingUserinfoController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    SCPRequestManager * _request;
    UIImageView * _portraitView;
    UITextField * _nameFiled;
    UITextView * _description;
    UIImageView * _imageview;
}
@end
