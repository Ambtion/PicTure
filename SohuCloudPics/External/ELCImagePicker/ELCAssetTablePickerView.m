//
//  ELCAssetTablePickerViewController.m
//  SohuCloudPics
//
//  Created by sohu on 13-2-26.
//
//

#import "ELCAssetTablePickerView.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SCPAlertView_LoginTip.h"


@implementation ELCAssetTablePickerView

@synthesize parent;
@synthesize assetGroup, elcAssets;
@synthesize delController;
@synthesize tableView = _tableView;

-(void)viewDidLoad {
    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    CGRect rect = self.tableView.frame;
    rect.origin.y -= 20;
    rect.size.height = self.view.frame.size.height - 121 + 20;
    self.tableView.frame = rect;
    [self.view addSubview:self.tableView];
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44 + 20)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
	[self.tableView setAllowsSelection:NO];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitle:@"图片"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self preparePhotos];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)preparePhotos {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.elcAssets = [self revertObjectArray:self.elcAssets];
                 [self.tableView reloadData];
             });
         }
     }];
    [pool release];
}
- (NSMutableArray *)revertObjectArray:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = array.count - 1; i >= 0; i--)
        [finalArray addObject:[array objectAtIndex:i]];
    return finalArray;
}
- (void) doneAction:(id)sender {
	
	NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
    
	for(ELCAsset *elcAsset in self.delController.assetList)
    {
        [selectedAssetsImages addObject:elcAsset.asset];
	}
    [(ELCAlbumPickerViewController*)self.parent selectedAssets:selectedAssetsImages];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 79;
}

- (int)totalSelectedAssets
{
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (ELCAsset *asset in self.elcAssets) {
        asset.parent = nil;
    }
    self.elcAssets = nil;
    self.delController = nil;
    [super dealloc];
}

@end
