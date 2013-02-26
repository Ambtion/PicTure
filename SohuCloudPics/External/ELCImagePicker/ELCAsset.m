//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePickerView.h"
#import "SCPAlertView_LoginTip.h"


@implementation ELCAsset

@synthesize parent;
@synthesize toggleDelegate;
@synthesize overlayView = _overlayView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        toggleDelegate = nil;
    }
    return self;
    
}

-(id)initWithAsset:(ALAsset*)Aasset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {

		_asset = [Aasset retain];
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
        assetImageView.tag = 100;
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[_asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		_overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[_overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[_overlayView setHidden:YES];
		[self addSubview:_overlayView];
    }
    
	return self;	
}
#pragma mark -
#pragma mark  setMethod for asset
- (ALAsset *)asset
{
    return _asset;
}
-(void)setAsset:(ALAsset *)asset
{
    if ([_asset defaultRepresentation].url != [asset defaultRepresentation].url) {
        [_asset release];
        _asset = [asset retain];
        UIImageView* imageView = (UIImageView*)[self viewWithTag:100];
        imageView.image = [UIImage imageWithCGImage:[_asset thumbnail]];
        
    }
}
-(void)toggleSelection {
    
    //图片点击的时候
//    NSLog(@"self %@",_asset);
    if(self.parent == nil && (!_overlayView.hidden)){
        if(toggleDelegate){
            _overlayView.hidden = !_overlayView.hidden;
            [toggleDelegate onToggle:self isSelected:_overlayView.hidden];
        }else {
            _overlayView.hidden = !_overlayView.hidden;
        }
        return;
    }
    if([(ELCAssetTablePickerView*)self.parent totalSelectedAssets] >= 10 && _overlayView.hidden) {
        SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"选择数量已达上限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tip show];
        [tip release];
    }
    else {
        if(toggleDelegate){
            if ([toggleDelegate onToggle:self isSelected:!_overlayView.hidden]) {
                _overlayView.hidden = !_overlayView.hidden;
            }
        }else {
                _overlayView.hidden = !_overlayView.hidden;
        }
    }
    if ([_target respondsToSelector:_action] ){
        [_target performSelector:_action];
        
    }
}
-(void)addtarget:(id)target andAction:(SEL)action
{
    _target = target;
    _action = action;
}
-(BOOL)selected {
	
	return !_overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[_overlayView setHidden:!_selected];
}

- (void)dealloc {
    self.toggleDelegate = nil;
    self.asset = nil;
	[_overlayView release];
    [super dealloc];
}

@end

