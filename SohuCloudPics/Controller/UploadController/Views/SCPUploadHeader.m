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

#define DESLABEL @"网络专辑获取中"
#define MAXLIMITNUM 1000
#define OFFSET 5
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
@synthesize albumChooseLabel = _albumChooseLabel;
@synthesize albumChooseButton = _albumChooseButton;
@synthesize albumNameLabel = _albumNameLabel;
@synthesize iconImageView = _iconImageView;
@synthesize labelBoxLabel = _labelBoxLabel;

- (void)dealloc
{
    [_requestmanager setDelegate:nil];
    [_requestmanager release];
    [_foldersArray release];
    [_albumsTable release];
    [_manager release];
    [_albumChooseLabel release];
    [_albumNameLabel release];
    [_iconImageView release];
    [_albumChooseButton release];
    [_activity release];
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
    
    UIImageView * titleImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_uploads_photos.png"]] autorelease];
    titleImage.frame = CGRectMake(110, 43, 100, 24);
    [self.contentView addSubview:titleImage];
    
    // album choose
    _albumChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 86 + 10, 300, 20)];
    [UIUtils updateNormalLabel:_albumChooseLabel title:@"请选择一个专辑"];
    [self addSubview:_albumChooseLabel];
    _currentAlbum = 0;
    
    _albumChooseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _albumChooseButton.frame = CGRectMake(10, 111 + 10, 300, 40);
    _albumChooseButton.tag = 0;
    [_albumChooseButton addTarget:self action:@selector(albumChooseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_albumChooseButton];
    
    _albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, _albumChooseButton.frame.size.width - 80, _albumChooseButton.frame.size.height)];
    _albumNameLabel.backgroundColor = [UIColor clearColor];
    _albumNameLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
    _albumNameLabel.font = [_albumChooseButton.titleLabel.font fontWithSize:15];
    _albumNameLabel.textAlignment = UITextAlignmentLeft;
    _albumNameLabel.text = DESLABEL;
    [_albumChooseButton addSubview:_albumNameLabel];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 30, 30)];
    [_albumChooseButton addSubview:_iconImageView];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.frame = CGRectMake(_albumChooseButton.frame.size.width - 80 , 0, 40, 40);
    _activity.hidesWhenStopped = YES;
    [_albumChooseButton addSubview:_activity];
    
    _albumsTable = [[UITableView alloc] initWithFrame:CGRectMake(10, _albumChooseButton.frame.origin.y + _albumChooseButton.frame.size.height + 2, _albumChooseButton.frame.size.width, 120) style:UITableViewStylePlain];
    _albumsTable.layer.borderWidth = 1.0;
    _albumsTable.layer.borderColor = [UIColor colorWithRed:209.f/255 green:209.f/255 blue:209.f/255 alpha:1].CGColor;
    
}
- (void)initManager
{
    
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
    [_activity startAnimating];
    [_foldersArray removeAllObjects];
    [_requestmanager getFoldersWithID:[SCPLoginPridictive currentUserId] page:1];
}

#pragma mark  Method Network
- (void)requestFinished:(SCPRequestManager *)mangeger output:(NSDictionary *)info
{
    NSArray * array = [[info objectForKey:@"folderinfo"] objectForKey:@"folders"];
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
            [_albumChooseButton setImage:[UIImage imageNamed:@"add_new_albume_btn_normal.png"] forState:UIControlStateNormal];
            [_albumChooseButton setImage:[UIImage imageNamed:@"add_new_albume_btn_press.png"] forState:UIControlStateHighlighted];
        }else{
            [_albumChooseButton setImage:[UIImage imageNamed:@"share_btn_down_normal.png"] forState:UIControlStateNormal];
            [_albumChooseButton setImage:[UIImage imageNamed:@"share_btn_down_press.png"] forState:UIControlStateHighlighted];
            self.currentAlbum = 0;
        }
    }
    [_activity stopAnimating];
}
- (void)requestFailed:(NSString *)error
{
    
    SCPAlert_CustomeView * cus = [[[SCPAlert_CustomeView alloc] initWithTitle:@"当前网络不给力，请稍后重试"] autorelease];
    [cus show];
    _albumNameLabel.text = @"网络专辑获取失败";
    [self setUserInteractionEnabled:NO];
    [_activity stopAnimating];
    if ([_delegate respondsToSelector:@selector(uploadHeader:selectAlbum:)])
        [_delegate performSelector:@selector(uploadHeader:selectAlbum:) withObject:nil withObject:nil];
    
}
#pragma mark Create Folder
- (void)renameAlertView:(SCPAlert_Rename *)view OKClicked:(UITextField *)textField
{
    if (!textField.text ||[textField.text isEqualToString:@""]) return;
    if (self.albumChooseButton.selected)
        [self albumChooseButtonClicked];
    [_requestmanager createAlbumWithName:textField.text success:^(NSString *response) {
        [self dismissAlbumChooseTable];
        [self refreshData];
    } failure:^(NSString *error) {
        [self dismissAlbumChooseTable];
        SCPAlert_CustomeView * alterview = [[[SCPAlert_CustomeView alloc] initWithTitle:error] autorelease];
        [alterview show];
    }];
}
#pragma mark -

- (void)albumChooseButtonClicked
{
    if (!_foldersArray.count) {
        if ([self.delegate respondsToSelector:@selector(uploadHeadershowCreateAlertView:)])
            [self.delegate performSelector:@selector(uploadHeadershowCreateAlertView:) withObject:self];
        SCPAlert_Rename * aln = [[[SCPAlert_Rename alloc] initWithDelegate:self name:@"输入名称"] autorelease];
        [aln show];
        return;
    }
    _albumChooseButton.tag = !_albumChooseButton.tag;
    if (_albumChooseButton.tag) {
        // very very bad design, must be fixed later!!!
        UITableView *table = (UITableView *) self.superview;
        _albumsTable.frame = CGRectMake(10, _albumsTable.frame.origin.y  - table.contentOffset.y, _albumChooseButton.frame.size.width, _foldersArray.count * 40 + 40  > 200 ? 200 + OFFSET :_foldersArray.count * 40 + 40 + OFFSET);
        [self.superview.superview addSubview:_albumsTable];
        [self.superview.superview bringSubviewToFront:_albumsTable];
        [_albumsTable becomeFirstResponder];
        [_albumsTable flashScrollIndicators];
    } else {
        [_albumsTable removeFromSuperview];
    }
}
- (void)dismissAlbumChooseTable
{
    _albumChooseButton.selected = NO;
    [_albumsTable removeFromSuperview];
}

- (void)setCurrentAlbum:(NSInteger)currentAlbum
{
    _currentAlbum = currentAlbum;
    FoldersMode * mode = (FoldersMode *)[_foldersArray objectAtIndex:_currentAlbum];
    _albumNameLabel.text = mode.foldrsName;
    _iconImageView.image = mode.isPublic ? [UIImage imageNamed:@"unlock_icon.png"] : [UIImage imageNamed:@"lock_icon.png"];
    if ([_delegate respondsToSelector:@selector(uploadHeader:selectAlbum:)])
        [_delegate performSelector:@selector(uploadHeader:selectAlbum:) withObject:self withObject:mode.folders_Id];
}


@end
@implementation AlbumsTableManager

@synthesize header = _header;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    SCPNewFoldersCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewFolders"];
    if (!cell) {
        cell = [[[SCPNewFoldersCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewFolders"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (row == 0) {
        
        cell.mylabelText.text = @"新建私密专辑";
        cell.mylabelText.frame = CGRectMake(40, 0, 280, 40);
        cell.iconView.image = [UIImage imageNamed:@"add_album_icon.png"];
        cell.mydetailText.text = nil;
    }else{
        cell.mylabelText.frame = CGRectMake(40, 4, 240, 18);
        FoldersMode * model = [_header.foldersArray objectAtIndex:(row - 1)];
        cell.mylabelText.text = model.foldrsName;
        if (model.isPublic) {
            cell.mydetailText.text = @"公开专辑";
            
        }else{
            cell.mydetailText.text = @"私密专辑";
        }
        cell.iconView.image = model.isPublic ? [UIImage imageNamed:@"unlock_icon.png"] : [UIImage imageNamed:@"lock_icon.png"];
    }
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
        if ([_header.delegate respondsToSelector:@selector(uploadHeadershowCreateAlertView:)])
            [_header.delegate performSelector:@selector(uploadHeadershowCreateAlertView:) withObject:_header];
        
        SCPAlert_Rename * aln = [[[SCPAlert_Rename alloc] initWithDelegate:_header name:@"输入名称"] autorelease];
        [aln show];
    
    } else {
        _header.currentAlbum = row - 1;
        [_header albumChooseButtonClicked];
    }
}
@end

