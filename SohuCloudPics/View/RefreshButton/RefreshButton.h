//
//  RefreshButton.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RefreshButton : UIButton
{
    id myTarget;
    SEL myAction;
    
}
- (void)rotateButton;
@end
