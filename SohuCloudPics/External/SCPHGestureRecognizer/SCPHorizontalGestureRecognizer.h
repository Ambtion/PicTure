//
//  SCPHorizontalGestureRecognizer.h
//  SohuCloudPics
//
//  Created by Chen Chong on 12-10-26.
//
//

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface SCPHorizontalGestureRecognizer : UIGestureRecognizer
{
    CFAbsoluteTime _beginTime;
    float _totalDeltaX;
}

@property (assign, nonatomic) UISwipeGestureRecognizerDirection direction;

@end
