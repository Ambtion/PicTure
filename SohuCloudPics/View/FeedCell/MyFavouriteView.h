//
//  MyFavouriteView.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-21.
//
//

#import <UIKit/UIKit.h>

@interface MyFavouriteView : UIView
{
    UITapGestureRecognizer * tap;
    
}
@property(nonatomic,retain)UILabel * textLabel;
@property(nonatomic,retain)UIImageView* imageView;

-(void)addtarget:(id)target action:(SEL)action;
@end
