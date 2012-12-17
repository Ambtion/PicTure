//
//  Asset.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class ELCAsset;

@protocol ELCAssetToggle <NSObject>

-(BOOL)onToggle:(ELCAsset *)asset isSelected:(BOOL)isSelected;

@end
@interface ELCAsset : UIView {
	ALAsset * _asset;
	UIImageView *_overlayView;
	BOOL selected;
	id parent;
    
    id _target;
    SEL _action;
}
@property (strong,nonatomic) id<ELCAssetToggle> toggleDelegate;
@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;
@property (nonatomic, retain)UIImageView * overlayView;
-(id)initWithAsset:(ALAsset*)Aasset;
-(BOOL)selected;
-(void)toggleSelection; 
-(void)addtarget:(id)target andAction:(SEL)action;
@end
