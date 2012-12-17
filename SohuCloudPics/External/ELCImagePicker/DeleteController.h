//
//  DeleteController.h
//  ELCImagePickerDemo
//
//  Created by mysohu on 12-8-13.
//  Copyright (c) 2012年 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"
#import "ImageEdtingController.h"

@interface DeleteController : UITabBarController <ELCAssetToggle,ImageEdtingDelegate>{
    UILabel * label;
    UIImageView * bgimageView;
}
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *assetList;
@property (strong,nonatomic) NSMutableArray *viewList;
@property (strong,nonatomic) NSString * Grouptitle;
-(void)onDeleteButtonClicked:(id)sender;
@end
