//
//  MenuButtonView.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuButtonView;
@protocol MenuButtonViewDelegate <NSObject>

-(void)menu:(MenuButtonView*)menuView ButtonClick:(UITapGestureRecognizer *)gesture;
@end

@interface MenuButtonView : UIView
{
    UITapGestureRecognizer * _gesture;
}
@property(nonatomic,retain)UILabel * nameLabel;
@property(nonatomic,retain)UILabel * numlabel;
@property(nonatomic,assign)id<MenuButtonViewDelegate> delegate;
@end
