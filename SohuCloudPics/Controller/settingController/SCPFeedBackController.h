//
//  SCPFeedBackController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "SCPSecondController.h"
#import "SCPRequestManager.h"

@interface SCPFeedBackController : SCPSecondController<UITextViewDelegate,UIGestureRecognizerDelegate,SCPRequestManagerDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    SCPRequestManager * _requset;
    UIButton * _saveButton;
    UIView * _textView_bg;
}
@end
