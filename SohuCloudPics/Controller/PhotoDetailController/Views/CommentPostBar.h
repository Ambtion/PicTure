//
//  CommentPostBar.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentPostBar;

@protocol CommentPostBarDelegate <NSObject>
@required
- (void)commentPostBar:(CommentPostBar *)bar postComment:(NSString *)comment;
@end


@interface CommentPostBar : UIView

@property (assign, nonatomic) id <CommentPostBarDelegate> delegate;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UITextField *commentTextField;
@property (strong, nonatomic) UIButton *postButton;

@end
