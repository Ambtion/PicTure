//
//  ALbumControllerManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-31.
//
//

#import "AlbumControllerManager.h"


@implementation AlbumControllerManager

- (id)initWithpresentController:(id)controller
{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    ELCAlbumPickerViewController * albumController = [[[ELCAlbumPickerViewController alloc] init] autorelease];
    ELCImagePickerNavController * elcPicker = [[ELCImagePickerNavController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
    [elcPicker setDelegate:self];
    
    DeleteController *delCtrl = [[[DeleteController alloc] initWithNibName:nil bundle:nil] autorelease];
    delCtrl.viewControllers  = [NSArray arrayWithObject:elcPicker];
    albumController.delController = delCtrl;
    elcPicker.backTo = controller;
    self = [super initWithRootViewController:delCtrl];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.navigationBar.tintColor = [UIColor clearColor];
        [self.navigationBar setHidden:YES];
    }
    return self;
}

- (UIViewController * )popViewControllerAnimated:(BOOL)animated
{
    UIViewController * tc = [super popViewControllerAnimated:animated];
    return tc;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count == 1){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    [super pushViewController:viewController animated:animated];
    return ;
}

@end
