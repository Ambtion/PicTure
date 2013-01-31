//
//  SCPDescriptionEditController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-15.
//
//

#import <UIKit/UIKit.h>
#import "SCPRequestManager.h"

@interface PhotoDesEditController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    SCPRequestManager * _requset;
    UIButton * _saveButton;
    UIView * _textView_bg;
}
@property(nonatomic,retain)NSString * photo_id;
//图片原有的描述
@property(nonatomic,retain)NSString * originalDes;
- (id)initphoto:(NSString *)photo_id withDes:(NSString * )des ;
@end
