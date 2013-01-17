//
//  AssetTablePicker.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
#import <QuartzCore/QuartzCore.h>
#import "SCPAlertView_LoginTip.h"

@implementation ELCAssetTablePicker

@synthesize parent;
@synthesize selectedAssetsLabel;
@synthesize assetGroup, elcAssets;
@synthesize delController;
-(void)viewDidLoad {
        
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    [self.navigationItem setTitle:@"图片"];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
	
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
//	[self.navigationItem setTitle:@"Loading..."];

	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    // Show partial while full list loads
//	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5];    
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect rect = self.view.frame;
    NSLog(@"NSS ^^^^^^^^ %@",NSStringFromCGRect(rect));
    rect.size.height = self.view.frame.size.height - 121;
    self.view.frame = rect;

}
-(void)preparePhotos {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"%@",self.parentViewController.parentViewController);
    NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {         
         if(result == nil){
             return;
         }
         ELCAsset *elcAsset = nil;
         for (ELCAsset *asset in self.delController.assetList) {
             if([asset.asset.defaultRepresentation.url isEqual:result.defaultRepresentation.url]){
                 elcAsset = asset;
                 break;
             }
         }
         if (elcAsset == nil) {
             elcAsset = [[[ELCAsset alloc] initWithAsset:result] autorelease];
         }
         [elcAsset setParent:self];
         elcAsset.toggleDelegate = self.delController;
         [self.elcAssets addObject:elcAsset];
         if (index == [self.assetGroup numberOfAssets] - 1) {
             NSLog(@"done enumerating photos");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }
     }];
    [pool release];

}

- (void) doneAction:(id)sender {
	
	NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
	    
	for(ELCAsset *elcAsset in self.delController.assetList) 
    {		
        [selectedAssetsImages addObject:elcAsset.asset];
	}

    [(ELCAlbumPickerController*)self.parent selectedAssets:selectedAssetsImages];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.assetGroup numberOfAssets] / 4.0);
}

- (NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
	if(maxIndex < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				[self.elcAssets objectAtIndex:index+2],
				[self.elcAssets objectAtIndex:index+3],
				nil];
	}
    
	else if(maxIndex-1 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				[self.elcAssets objectAtIndex:index+2],
				nil];
	}
    
	else if(maxIndex-2 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				nil];
	}
    
	else if(maxIndex-3 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObject:[self.elcAssets objectAtIndex:index]];
	}
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
    {		        
        cell = [[[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if(indexPath.row >= ([self.elcAssets count] - 1)/4) 
//        return 112;
	return 79;
}

- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(ELCAsset *asset in self.elcAssets) 
    {
		if([asset selected]) 
        {            
            count++;	
		}
	}
    
    return count;
}

- (void)dealloc 
{
    for (ELCAsset *asset in self.elcAssets) {
        asset.parent = nil;
    }
    self.elcAssets = nil;
    self.delController = nil;
    [selectedAssetsLabel release];
    [super dealloc];    
}

@end
