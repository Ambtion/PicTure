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
    
    //    UIButton * button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)] autorelease];
    //    [button setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    //
    //    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem * cancelButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	[self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [cancelButtonItem release];
    
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
                           
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"请确认", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           [alert release];
                           NSLog(@"A problem occured %@", [error description]);
                       };
                       
                       // Enumerate Albums
                       [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                              usingBlock:assetGroupEnumerator
                                            failureBlock:assetGroupEnumberatorFailure];
                       [pool release];
                   });
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    [self cancelAction:nil];
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
	[self.navigationItem setTitle:@"相册"];
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

