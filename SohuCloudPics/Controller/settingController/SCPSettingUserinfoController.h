//
//  SCPSettingUserinfoController.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"
#import "SCPSecondController.h"

@interface SCPSettingUserinfoController : SCPSecondController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

{
    SCPRequestManager * _request;
    UIImageView * _portraitView;
    UITextField * _nameFiled;
    UITextView * _description;
    UIImageView * _imageview;
    UITextField * _placeHolder;
    UIView * textView_bg;
}
@property(nonatomic,assign)id controller;
@end
