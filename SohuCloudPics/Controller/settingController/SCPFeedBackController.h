//
//  SCPFeedBackController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "SCPSecondLayerController.h"

@interface SCPFeedBackController : SCPSecondLayerController<UITextViewDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
}
@end
