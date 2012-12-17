//
//  SCPAlert_DetailView.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-10.
//
//

#import <UIKit/UIKit.h>
#import "SCPAlbum.h"

@class SCPAlert_DetailView;

@protocol SCPAlert_DetailViewDelegate <NSObject>
@optional
- (void)alertView:(SCPAlert_DetailView *)view alertViewOKClicked:(UIButton *)button;
@end

@interface SCPAlert_DetailView : UIView
{
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UILabel *_descLabel;
    UIButton *_cancelButton;
    UIButton *_okButton;
    id<SCPAlert_DetailViewDelegate> _delegate;
}
- (id)initWithMessage:(SCPAlbum *)album delegate:(id<SCPAlert_DetailViewDelegate>)delegate;
- (void)show;


@end
