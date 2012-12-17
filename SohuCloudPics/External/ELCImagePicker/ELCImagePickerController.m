//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"

#import "SCPUploadController.h"

@implementation ELCImagePickerController
@synthesize backTo;
@synthesize delegate;

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    return self;
}
-(void)cancelImagePicker {
	if([delegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.backTo dismissModalViewControllerAnimated:YES];
}

-(void)selectedAssets:(NSArray*)_assets {
    
    NSString * assetsFinish;
    if (_assets.count == 0 || !_assets) {
        UIAlertView * alter = [[[UIAlertView alloc] initWithTitle:@"请选择图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alter show];
        return;
    }
    NSLog(@"selectedAssets");
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	for(ALAsset *asset in _assets) {

		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
//        [workingDictionary setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]] forKey:@"UIImagePickerControllerOriginalImage"];
//		[workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
        
        [workingDictionary setObject:asset.defaultRepresentation.url forKey:@"UIImagePickerControllerRepresentationURL"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[asset thumbnail] ]forKey:@"UIImagePickerControllerThumbnail"];
		[returnArray addObject:workingDictionary];
		
		[workingDictionary release];	
	}
	
	if([delegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[delegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	}
    
    SCPUploadController * ctrl = [[[SCPUploadController alloc] initWithImageToUpload:returnArray :self.backTo] autorelease];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    NSLog(@"deallocing ELCImagePickerController");
    self.backTo = nil;
    [super dealloc];
}

@end
