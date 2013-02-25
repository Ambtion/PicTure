//
//  ELCImagePickerNavController.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-25.
//
//

#import <UIKit/UIKit.h>

@interface ELCImagePickerNavController : UINavigationController
{
	id delegate;
}
@property(strong,nonatomic) UIViewController *backTo;
@property (nonatomic, assign) id delegate;

-(void)selectedAssets:(NSArray*)_assets;
-(void)cancelImagePicker;

@end

@protocol ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerNavController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerNavController *)picker;

@end
