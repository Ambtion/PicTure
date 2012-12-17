//
//  SCPLabelBox.h
//  SohuCloudPics
//
//  Created by Zhong Sheng on 12-9-19.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SCPLabelColorStyleRed = 0,
    SCPLabelColorStyleBlue = 1,
    SCPLabelColorStyleGreen = 2,
    SCPLabelColorStyleYellow = 3,
    SCPLabelColorStyleLightBlue = 4,
} SCPLabelColorStyle;



@interface SCPLabelObject : NSObject

@property (strong, nonatomic, readonly) NSString *labelContent;
@property (assign, nonatomic, readonly) SCPLabelColorStyle labelColorStyle;

- (id)initWithContent:(NSString *)content colorStyle:(SCPLabelColorStyle)style;

@end


@class SCPLabelBox;

@protocol SCPLabelBoxDelegate <NSObject>
@optional
- (void)SCPLabelBox:(SCPLabelBox *)labelBox addLabelButtonClicked:(id)sender;
- (void)SCPLabelBox:(SCPLabelBox *)labelBox clickedAtIndex:(NSInteger)index label:(id)sender;

@end


@interface SCPLabelBox : UITableViewCell
{
    NSMutableArray *_labelObjects;
    CGPoint _insertPoint;
}

@property (assign, nonatomic) id <SCPLabelBoxDelegate> delegate;

@property (strong, nonatomic) UIButton *addLabelButton;

- (NSInteger)labelObjectCount;
- (SCPLabelObject *)labelObjectAtIndex:(NSInteger)index;
- (BOOL)labelObjectContains:(SCPLabelObject *)labelObj;

- (void)addLabel:(SCPLabelObject *)labelObject;
- (void)removeLabelAtIndex:(NSInteger)index;

@end



@class SCPLabelChooser;

@protocol SCPLabelChooserDelegate <NSObject>
@optional
- (void)SCPLabelChooser:(SCPLabelChooser *)chooser foldButtonClicked:(id)sender;
//- (void)SCPLabelChooser:(SCPLabelChooser *)chooser clickedAtIndex:(NSInteger)index label:(id)sender;
- (void)SCPLabelChooser:(SCPLabelChooser *)chooser clickedAtObj:(SCPLabelObject *)object;

@end



@interface SCPLabelChooser : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) id <SCPLabelChooserDelegate> delegate;

@property (strong, nonatomic, readonly) NSArray *labelObjects;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *titleBackgroundImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *foldButton;
@property (strong, nonatomic) UIScrollView *labelScroll;
@property (strong, nonatomic) UIPageControl *labelPageControl;

- (id)initWithLabels:(NSArray *)labels;

@end
