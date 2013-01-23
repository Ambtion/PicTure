//
//  DeleteController.m
//  ELCImagePickerDemo
//
//  Created by mysohu on 12-8-13.
//  Copyright (c) 2012年 ELC Technologies. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DeleteController.h"
#import "TabCell.h"

#import "ImageEdtingController.h"

#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

#define CONTENT_SIZE 84
@interface DeleteController ()

@end

@implementation DeleteController
@synthesize viewList,assetList;
@synthesize scrollView;
@synthesize Grouptitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)makeTabBarHidden:(BOOL)hide
{
    if ( [self.view.subviews count] < 2 )
        return;
    
    UIView *contentView;
    
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hide )
    {
        contentView.frame = self.view.bounds;
    }
    else
    {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    
    self.tabBar.hidden = hide;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeTabBarHidden:YES];
    assetList = [[NSMutableArray alloc] initWithCapacity:0];
    viewList = [[NSMutableArray alloc] initWithCapacity:0];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 121, 320, 121)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    UIImageView * imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drewer_bg.png"]] autorelease];
    imageView.frame = scrollView.frame;
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:imageView];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height - 121, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    label.text = @"一次可以上传10张图片";
    [self.view addSubview:label];
    
    bgimageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload_defoult_bg.png"]];
    bgimageView.frame = CGRectMake((320 - 235)/2.f, 55, 235, 30);
    [imageView addSubview:bgimageView];
    
	// Do any additional setup after loading the view.
}
- (void)dealloc
{
    self.Grouptitle = nil;
    self.assetList = nil;
    self.viewList = nil;
    [label release];
    [bgimageView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    
    self.assetList = nil;
    self.viewList = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -
#pragma add and del
-(BOOL)addImage:(UIImage *)image{
    
    float curWidth = (viewList.count+1)*CONTENT_SIZE;
    scrollView.contentSize = CGSizeMake(curWidth>320?curWidth:320, CONTENT_SIZE);
    TabCell * cell = [[TabCell alloc] initWithFrame:CGRectMake(viewList.count*CONTENT_SIZE, 40, CONTENT_SIZE, CONTENT_SIZE)];
    
    [cell.delBtn addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(onEditButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageView.image = image;
    
    //for search tag
    cell.tag = viewList.count;
    
    [viewList addObject:cell];
    [scrollView addSubview:cell];
    
    if(viewList.count>4){
        CGPoint point = scrollView.contentOffset;
        point.x += CONTENT_SIZE;
        scrollView.contentOffset = point;
    }
    [cell release];
    
    return TRUE;
}
-(BOOL)delImage:(int)position{
    UIView * view = [viewList objectAtIndex:position];
    [view removeFromSuperview];
    [viewList removeObjectAtIndex:position];
    
    //move scrollView content to left
    for (int i = position; i < viewList.count; i++) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3];
        UIView *view = [viewList objectAtIndex:i];
        
        //for search tag
        view.tag -= 1;
        
        CGPoint curPoint = view.layer.position;
        curPoint.x -= CONTENT_SIZE;
        view.layer.position = curPoint;
        
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view cache:YES];
        [UIView setAnimationRepeatCount:1.0];

        [UIView commitAnimations];

    }
    CGSize scrollSize = scrollView.contentSize;
    scrollSize.width -= CONTENT_SIZE;
    scrollView.contentSize = scrollSize;
    return true;
}
-(void)onDeleteButtonClicked:(id)sender{
    
    UIView *view = ((UIView *)sender).superview;
    int position = [viewList indexOfObject:view];
    if(position != NSNotFound){
        ELCAsset *asset = [assetList objectAtIndex:position];
        [asset toggleSelection];
    }
}

-(void)updataLabel
{
    label.text = [NSString stringWithFormat:@"每次可上传10张图片,已选择%d张",assetList.count];
    if (assetList.count == 0 && bgimageView.superview == nil ) {
        [scrollView addSubview:bgimageView];
    }
    if (assetList.count != 0 && bgimageView.superview ) {
        [bgimageView removeFromSuperview];
    }
}
-(void)onEditButton:(UIButton *)button
{
    ELCAsset *myasset = [assetList objectAtIndex:button.superview.tag];
        
    ImageEdtingController * iet = [[[ImageEdtingController alloc] initWithAsset:
                                    [myasset.asset defaultRepresentation].url info:myasset :button.superview.tag]autorelease];
    iet.groupName = self.Grouptitle;
    iet.delegate = self;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self presentModalViewController:iet animated:YES];
    
}
#pragma mark - 
#pragma mark imageEdting delegate
- (void)imageEdtingDidBack:(ImageEdtingController *)imageEdting
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imageEdtingDidSave:(ImageEdtingController *)imageEdting imageinfo:(NSURL *)assetURL info:(id)info num:(NSInteger)tag
{
    [UIApplication sharedApplication].statusBarHidden = NO;

    ELCImagePickerController * pic = (ELCImagePickerController *)[self.viewControllers objectAtIndex:0];
    ELCAlbumPickerController * alb = [pic.viewControllers objectAtIndex:0];
    ALAssetsLibrary * lib = alb.library;
    [lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ELCAsset *myasset = (ELCAsset *)info;
            myasset.asset = asset;
            TabCell * cell =  [self.viewList objectAtIndex:tag];
            cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
            
            [self dismissModalViewControllerAnimated:YES];
        });
    } failureBlock:^(NSError *error) {
//        NSLog(@"%@,%@",[self class],error);
    }];
    
}
#pragma mark -
#pragma mark toggle ELCAsset Delegate method
-(BOOL)onToggle:(ELCAsset *)asset isSelected:(BOOL)isSelected{
    
    //选择图片
    ALAsset *alAsset = asset.asset;
    
    //uncheck -> checked
    if (!isSelected) {
        for (ELCAsset *elcAsset in assetList) {
            NSURL * url = elcAsset.asset.defaultRepresentation.url;
            if ([url isEqual:alAsset.defaultRepresentation.url]) {
                return FALSE;
            }
        }
//        NSLog(@"%@",asset.asset);
//        NSData * data = [asset.asset valueForProperty:ALAssetPropertyDate];
//        NSLog(@"%@",[data description]);
//        NSLog(@"%@",[asset.asset thumbnail]);
        [assetList addObject:asset];
        
        [asset addtarget:self andAction:@selector(updataLabel)];
        
        UIImage * image = [UIImage imageWithCGImage:[asset.asset thumbnail]];
        [self addImage:image];
        return TRUE;
    }else {//checked -> uncheck
        for (int i = 0; i < assetList.count; i++) {
            ELCAsset *elcAsset = [assetList objectAtIndex:i];
            NSURL *url = elcAsset.asset.defaultRepresentation.url;
            if ([url isEqual:alAsset.defaultRepresentation.url]) {
                [self delImage:i];
                [assetList removeObjectAtIndex:i];

                [asset addtarget:self andAction:@selector(updataLabel)];

                return TRUE;
            }
        }
        return FALSE;
    }
}

@end
