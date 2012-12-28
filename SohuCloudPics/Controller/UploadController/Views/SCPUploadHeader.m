//
//  SCPUploadHeader.m
//  SohuCloudPics
//
//  Created by mysohu on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPUploadHeader.h"

#import <QuartzCore/QuartzCore.h>

#import "UIUtils.h"
#import "SCPLoginPridictive.h"
#import "SCPAlert_CustomeView.h"
#import "SCPNewFoldersCell.h"

@interface AlbumsTableManager : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) SCPUploadHeader *header;
@end
@implementation FoldersMode
@synthesize folders_Id,foldrsName,isPublic;
- (void)dealloc
{
    self.foldrsName = nil;
    self.folders_Id = nil;
    [super dealloc];
}
@end
@implementation SCPUploadHeader
@synthesize delegate = _delegate;
@synthesize currentAlbum = _currentAlbum;
@synthesize nameLabel = _nameLabel;
@synthesize albumChooseLabel = _albumChooseLabel;
@synthesize albumChooseButton = _albumChooseButton;
@synthesize albumNameLabel = _albumNameLabel;
@synthesize labelBoxLabel = _labelBoxLabel;

- (void)dealloc
{
    [_foldersArray release];
    [_albumsTable release];
    [_manager release];
    [_requestmanager release];
    
    [_nameLabel release];
    [_albumChooseLabel release];
    [_albumNameLabel release];
    [_albumChooseButton release];
    [_labelBoxLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 320, 180);
        [self addSubviews];
        [self initManager];
        
    }
    return self;
}
- (void)addSubviews
{
    // name title
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 36)];
    [UIUtils updateTitleLabel:_nameLabel title:@"分享图片"];
    [self addSubview:_nameLabel];
    
    // album choose
    _albumChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 86, 300, 20)];
    [UIUtils updateNormalLabel:_albumChooseLabel title:@"请选择一个目标相册"];
    [self addSubview:_albumChooseLabel];
    _currentAlbum = 0;
    
    _albumChooseButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _albumChooseButton.frame = CGRectMake(10, 111, 200, 40);
    _albumChooseButton.selected = NO;
 
    [_albumChooseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_up_normal.png"] forState:UIControlStateSelected];

    [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_down_normal.png"] forState:UIControlStateNormal];
    [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_down_press.png"] forState:UIControlStateHighlighted];
    
//    [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_up_press.png"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [_albumChooseButton addTarget:self action:@selector(albumChooseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_albumChooseButton];
    
    _albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
    _albumNameLabel.backgroundColor = [UIColor clearColor];
    _albumNameLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
    _albumNameLabel.font = [_albumChooseButton.titleLabel.font fontWithSize:15];
    _albumNameLabel.textAlignment = UITextAlignmentCenter;
//    _albumNameLabel.text = @"新建相册";
    
    [_albumChooseButton addSubview:_albumNameLabel];
    
    
    _albumsTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 156, 200, 120) style:UITableViewStylePlain];
    _albumsTable.layer.borderWidth = 1.0;
    _albumsTable.layer.cornerRadius = 3.0;
    
}
- (void)initManager
{
    NSLog(@"%s",__FUNCTION__);
    _foldersArray = [[NSMutableArray alloc] initWithCapacity:0];
    _manager = [[AlbumsTableManager alloc] init];
    _manager.header = self;
    _albumsTable.delegate = _manager;
    _albumsTable.dataSource = _manager;
    _requestmanager = [[SCPRequestManager alloc] init];
    _requestmanager.delegate = self;
    [self refreshData];
}
- (void)refreshData
{
    [_foldersArray removeAllObjects];
    [_requestmanager getFoldersWithID:[SCPLoginPridictive currentUserId] page:1];
}

#pragma mark  Method Network
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    NSArray * array = [[info objectForKey:@"folderinfo"] objectForKey:@"folders"];
    NSLog(@"%@",[array lastObject]);
    for (NSDictionary * dic in array) {
        FoldersMode * mode = [[FoldersMode alloc] init];
        mode.foldrsName = [dic objectForKey:@"folder_name"];
        mode.folders_Id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"folder_id"]];
        mode.isPublic = [[dic objectForKey:@"is_public"] boolValue];
        [_foldersArray addObject:mode];
        [mode release];
    }
    if ([[info objectForKey:@"has_next"] intValue]){
        [_requestmanager getFoldersWithID:[SCPLoginPridictive currentUserId] page:[[info objectForKey:@"page"] intValue] + 1];
        
    }else{
        
        [_albumsTable reloadData];

        if (array.count == 0) {
            [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"add_new_albume_btn_normal.png"] forState:UIControlStateNormal];
            [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"add_new_albume_btn_press.png"] forState:UIControlStateHighlighted];
        }else{
            [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_down_normal.png"] forState:UIControlStateNormal];
            [_albumChooseButton setBackgroundImage:[UIImage imageNamed:@"share_btn_down_press.png"] forState:UIControlStateHighlighted];
            self.currentAlbum = 0;
            
        }
    }
   
}
//- (void)requestFailed:(NSString *)error
//{
//    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
//    [alertView show];
//}
#pragma mark Create Folder
- (void)renameAlertView:(SCPAlert_Rename *)view OKClicked:(UITextField *)textField
{
    if (!textField.text ||[textField.text isEqualToString:@""]) return;
    [_requestmanager createAlbumWithName:textField.text success:^(NSString *response) {
        [self refreshData];
    } failure:^(NSString *error) {
        UIAlertView * alterview = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterview show];
        [alterview release];
    }];
}
#pragma mark -

- (void)albumChooseButtonClicked
{
    if (!_foldersArray.count) {
        SCPAlert_Rename * aln = [[[SCPAlert_Rename alloc] initWithDelegate:self name:@"专辑名"] autorelease];
        [aln show];
        return;
    }
    _albumChooseButton.selected = !_albumChooseButton.selected;
    if (_albumChooseButton.selected) {
        // very very bad design, must be fixed later!!!
        UITableView *table = (UITableView *) self.superview;
        _albumsTable.frame = CGRectMake(10, 156 - table.contentOffset.y, 200, 120);
        [self.superview.superview addSubview:_albumsTable];
        [self.superview.superview bringSubviewToFront:_albumsTable];
        [_albumsTable becomeFirstResponder];
    } else {
        [_albumsTable removeFromSuperview];
    }
}

- (void)dismissAlbumChooseTable
{
    _albumChooseButton.selected = NO;
    [_albumsTable removeFromSuperview];
}

//- (void)setAlbumsArray:(NSArray *)albumsArray
//{
//    if (_albumsArray != albumsArray) {
//        [_albumsArray release];
//        _albumsArray = [albumsArray retain];
//        [_albumsTable reloadData];
//        self.currentAlbum = _currentAlbum;
//
//    }
//}
- (void)setCurrentAlbum:(NSInteger)currentAlbum
{
    _currentAlbum = currentAlbum;
    FoldersMode * mode = (FoldersMode *)[_foldersArray objectAtIndex:_currentAlbum];
    _albumNameLabel.text = mode.foldrsName;
    if ([_delegate respondsToSelector:@selector(uploadHeader:selectAlbum:)])
        [_delegate performSelector:@selector(uploadHeader:selectAlbum:) withObject:self withObject:mode.folders_Id];
}

@end

@implementation AlbumsTableManager

@synthesize header = _header;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    if (row == 0) {
        SCPNewFoldersCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewFolders"];
        if (!cell) {
            cell = [[SCPNewFoldersCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewFolders"];
        }
        cell.labelText.text = @"新建相册";
        cell.addView.image = [UIImage imageNamed:@"add_new_albume.png"];
        return cell;
    }
    static NSString *REUSE_ID = @"__AlbumsTableManager";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_ID] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
    }
    cell.textLabel.text = ((FoldersMode *)[_header.foldersArray objectAtIndex:(row - 1)]).foldrsName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _header.foldersArray.count + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    if (row == 0) {
        SCPAlert_Rename * aln = [[[SCPAlert_Rename alloc] initWithDelegate:_header name:@"专辑名"] autorelease];
        [aln show];
    } else {
        _header.currentAlbum = row - 1;
        [_header albumChooseButtonClicked];
    }
}
@end

