//
//  SCPWatiAlterView.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-26.
//
//

#import <UIKit/UIKit.h>

@interface SCPAlert_WaitView : UIAlertView{
    
    UILabel *alertTextLabel;
    UIImageView *backgroundView;
    UIActivityIndicatorView * activity;
}

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) NSString *alertText;

- (id) initWithImage:(UIImage *)backgroundImage text:(NSString *)text;
@end
