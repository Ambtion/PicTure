//
//  SCPAlert_CustomeView.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import <UIKit/UIKit.h>
#import "SCPGuideViewExchange.h"

@interface SCPAlert_CustomeView : UIView

{
    UIImageView *_alertboxImageView;
    UILabel *_title;
    
}
- (id)initWithTitle:(NSString *)title;
- (void)show;

@end
