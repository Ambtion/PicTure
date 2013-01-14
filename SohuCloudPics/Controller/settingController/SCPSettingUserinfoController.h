//
//  SCPSettingUserinfoController.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"
#import "SCPSecondLayerController.h"

@interface SCPSettingUserinfoController : SCPSecondLayerController<UITextFieldDelegate,UITextViewDelegate>
{
    SCPRequestManager * _request;
    UIImageView * _portraitView;
    UITextField * _nameFiled;
    UITextView * _description;
    UIImageView * _imageview;
    UITextField * _placeHolder;
    UIView * textView_bg;

}
@end
