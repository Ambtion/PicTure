//
//  SCPDescriptionEditController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-15.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"

@interface SCPDescriptionEditController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    SCPRequestManager * _requset;
    UIButton * _saveButton;
    UIView * _textView_bg;
}
@property(nonatomic,retain)NSString * photo_id;
@property(nonatomic,retain)NSString * tmpDes;
- (id)initphoto:(NSString *)photo_id withDes:(NSString * )des ;
@end
