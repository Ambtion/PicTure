//
//  SCPAlter_DeletView.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import <UIKit/UIKit.h>


#define DELETE  [NSString stringWithFormat: @"确定删除图片?"]

@class SCPAlert_DeletView;

@protocol SCPAlertDeletViewDelegate <NSObject>
- (void)alertViewOKClicked:(SCPAlert_DeletView *)view;
@end

@interface SCPAlert_DeletView : UIView
{
    
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UILabel *_descLabel;
    UIButton *_cancelButton;
    UIButton *_okButton;
    
    id<SCPAlertDeletViewDelegate> _delegate;
}

- (id)initWithMessage:(NSString *)msg delegate:(id<SCPAlertDeletViewDelegate>)delegate;
- (void)show;
@end
