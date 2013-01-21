//
//  SCPAlert_Rename.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import <UIKit/UIKit.h>

@class SCPAlert_Rename;


@protocol SCPAlertRenameViewDelegate <NSObject>

- (void)renameAlertView:(SCPAlert_Rename *)view OKClicked:(UITextField *)textField;

@end

@interface SCPAlert_Rename : UIView<UITextFieldDelegate>
{
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UITextField *_renameField;
    UIButton * _okButton;
    id<SCPAlertRenameViewDelegate> _delegate;
}

- (id)initWithDelegate:(id<SCPAlertRenameViewDelegate>)delegate name:(NSString *)name;
- (void)show;


@end
