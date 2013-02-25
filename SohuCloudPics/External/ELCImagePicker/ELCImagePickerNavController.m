//
//  ELCImagePickerNavController.m
//  SohuCloudPics
//
//  Created by sohu on 13-2-25.
//
//

#import "ELCImagePickerNavController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"

#import "SCPUploadController.h"
#import "SCPAlertView_LoginTip.h"

@implementation ELCImagePickerNavController
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
    
    if (_assets.count == 0 || !_assets) {
        SCPAlertView_LoginTip * alter = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"请选择图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alter show];
        return;
    }
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	for(ALAsset *asset in _assets) {
        if (!asset) return ;
		NSMutableDictionary * workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:asset.defaultRepresentation.url forKey:@"UIImagePickerControllerRepresentationURL"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[asset aspectRatioThumbnail] ]forKey:@"UIImagePickerControllerThumbnail"];
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
    //    NSLog(@"ELC Image Picker received memory warning.");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    self.backTo = nil;
    [super dealloc];
}

@end

