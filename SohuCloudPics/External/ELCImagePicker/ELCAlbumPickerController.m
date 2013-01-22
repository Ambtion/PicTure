//
//  AlbumPickerController.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import "SCPMenuNavigationController.h"

@implementation ELCAlbumPickerController

@synthesize parent, assetGroups,library;
@synthesize delController;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeNavigation];
    [self readAlbum];
    
}

- (void) customizeNavigation
{
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
    [doneButtonItem release];
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	[self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [cancelButtonItem release];
    [self.navigationItem setTitle:@"相册"];
}
- (void)customizeNavigationWhenALbumCannotRead
{
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, [[UIScreen mainScreen] bounds].size.height - 64)] autorelease];
    if ([[UIScreen mainScreen] bounds].size.height > 480) {
        imageView.image  = [UIImage imageNamed:@"serect_bg_ios6.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"secret_bg.png"];
    }
    imageView.backgroundColor = [UIColor redColor];
    [imageView setUserInteractionEnabled:YES];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Iknow_btn_normal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Iknow_btn_press.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake((320 - 127)/2.f, imageView.frame.size.height - 50, 127, 42);
    [imageView addSubview:button];
    [self.tabBarController.view addSubview:imageView];
    
    [self.navigationItem setTitle:@"隐私设置"];
	[self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void) readAlbum
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    library = [[ALAssetsLibrary alloc] init];
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                       // Group enumerator Block
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil)
                           {
                               return;
                           }
                           [self.assetGroups addObject:group];
                           // Reload albums
                           [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                       };
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           [self customizeNavigationWhenALbumCannotRead];
//                           NSLog(@"A problem occured %@", [error description]);
                       };
                       // Enumerate Albums
                       [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                              usingBlock:assetGroupEnumerator
                                            failureBlock:assetGroupEnumberatorFailure];
                       [pool release];
                   });
}
- (void)doneAction:(id)sender
{
	
	NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
	for(ELCAsset *elcAsset in self.delController.assetList)
    {
        [selectedAssetsImages addObject:elcAsset.asset];
	}
    [self selectedAssets:selectedAssetsImages];
}
-(void)cancelAction:(id)sender
{
    [((ELCImagePickerController *)self.parent) cancelImagePicker];
}

-(void)reloadTableView
{
	[self.tableView reloadData];
}

-(void)selectedAssets:(NSArray*)_assets
{
	[(ELCImagePickerController*)parent selectedAssets:_assets];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName:@"ELCAssetTablePicker" bundle:[NSBundle mainBundle]];
	picker.parent = self;
    
    // Move me
    picker.assetGroup = [assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    picker.delController = self.delController;
    self.delController.Grouptitle  = [picker.assetGroup valueForProperty:ALAssetsGroupPropertyName];
	[self.navigationController pushViewController:picker animated:YES];
    
	[picker release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc
{
    self.delController = nil;
    [assetGroups release];
    [library release];
    [super dealloc];
}

@end

