//
//  SCPUploadController.m
//  SohuCloudPics
//
//  Created by mysohu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCPUploadController.h"

#import "SCPUploadCell.h"
#import "SCPMenuNavigationController.h"
#import "SCPAlert_CustomeView.h"
#import "SCPAlertView_LoginTip.h"
#import "EmojiUnit.h"
#import "SCPUploadTaskManager.h"

@implementation SCPUploadController

@synthesize keyboardHeight = _keyboardHeight;
@synthesize curAlbumID = _curAlbumID;
@synthesize albumList = _albumList;
@synthesize uploadHeader = _uploadHeader;
@synthesize uploadTableView = _uploadTableView;
@synthesize labelChooser = _labelChooser;
@synthesize descCell = _descCell;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_requsetManager setDelegate:nil];
    [_requsetManager release];
    [_preLabelObjs release];
    [_imageList release];
    [_cells release];
    [_selectButton release];
    self.curAlbumID = nil;
    [_albumList release];
    [_uploadHeader release];
    [_uploadTableView release];
    [_labelChooser release];
    [_descCell release];
    [super dealloc];
}

#pragma mark - init
- (id)initWithImageToUpload:(NSArray *)imageList : (id)decontrller
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        controller = decontrller;
        _requsetManager = [[SCPRequestManager alloc] init];
        _imageList = [[NSArray arrayWithArray:imageList] retain];
        int count = _imageList.count;
        NSMutableArray * mCells = [NSMutableArray arrayWithArray:0];
        
        for (int i = 0; i < count; ++i) {
            SCPUploadCell *cell = [[SCPUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.uploadController = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.portraitImageView.image = [[_imageList objectAtIndex:i] objectForKey:@"UIImagePickerControllerThumbnail"];
            [mCells addObject:cell];
            [cell release];
        }
        _cells = [[NSArray arrayWithArray:mCells] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _uploadHeader = [[SCPUploadHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _uploadHeader.selectionStyle = UITableViewCellEditingStyleNone;
    _uploadHeader.delegate = self;
    
    _descCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _descCell.selectionStyle = UITableViewCellEditingStyleNone;
    _descCell.textLabel.font = [UIFont systemFontOfSize:15];
    _descCell.textLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
    _descCell.textLabel.text = @"请对图片添加描述";
    _descCell.frame = CGRectMake(0, 0, 320, 20);
    
    _uploadTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _uploadTableView.autoresizesSubviews = YES;
    _uploadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uploadTableView.dataSource = self;
    _uploadTableView.delegate = self;
    _uploadTableView.bounces = NO;
    _uploadTableView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    [self.view addSubview:_uploadTableView];
    [self customizeNavigationBar];
    
}
- (void)customizeNavigationBar
{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, 2, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backTotop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _selectButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"header_OK.png"] forState:UIControlStateNormal];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"header_OK_press.png"] forState:UIControlStateHighlighted];
    [_selectButton addTarget:self action:@selector(dismissModalView:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.frame = CGRectMake(320 - 40, 2, 35, 35);
    [_selectButton setAlpha:0.3];
    [_selectButton setUserInteractionEnabled:NO];
    [self.view addSubview:_selectButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    if ([self.navigationController isKindOfClass:[SCPMenuNavigationController class]])
        [((SCPMenuNavigationController *) self.navigationController) setDisableMenu:YES];
    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController.navigationBar setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)resignFirstResponderForAll
{
    [_cells makeObjectsPerformSelector:@selector(resignmyFirstResponder)];
}
- (void)onUploadTableViewTapped:(id)sender
{
    [self resignFirstResponderForAll];
}

#pragma mark  UPData OK
- (void)dismissModalView:(UIButton*)button
{
    
    if (!self.curAlbumID) {
        SCPAlertView_LoginTip * alterView = [[[SCPAlertView_LoginTip alloc] initWithTitle:@"请选择专辑" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alterView show];
        return;
    }
    for(SCPUploadCell * cell in _cells) {
        if ([EmojiUnit stringContainsEmoji:cell.descTextView.text]) {
            SCPAlertView_LoginTip * tip = [[SCPAlertView_LoginTip alloc] initWithTitle:@"提示信息" message:@"图片描述包含非法字符,请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [tip show];
            [tip release];
            return;
        }
    }
    
    [self.view setUserInteractionEnabled:NO];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _imageList.count; i++) {
        SCPTaskUnit * unit = [[SCPTaskUnit alloc] init];
        NSDictionary * dic = [_imageList objectAtIndex:i];
        if ([dic objectForKey:@"UIImagePickerControllerRepresentationURL"]) {
            unit.asseetUrl = [dic objectForKey:@"UIImagePickerControllerRepresentationURL"];
        }else{
            unit.data = [dic objectForKey:@"ImageData"];
        }
        unit.thumbnail = [dic objectForKey:@"UIImagePickerControllerThumbnail"];
        SCPUploadCell * cell = [_cells objectAtIndex:i];
        unit.description = cell.descTextView.text;
        [array addObject:unit];
        [unit release];
    }
    SCPAlert_CustomeView * alertView = [[[SCPAlert_CustomeView alloc] initWithTitle:@"图片已在后台上传"] autorelease];
    [alertView show];
    SCPAlbumTaskList * album = [[[SCPAlbumTaskList alloc] initWithTaskList:array album_id:self.curAlbumID] autorelease];
    [[SCPUploadTaskManager currentManager] addTaskList:album];
    [controller performSelector:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5f];
}
#pragma mark Back
- (void)backTotop:(UIButton*)button
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark SCPUploadDelegate
- (void)uploadHeader:(SCPUploadHeader *)header selectAlbum:(NSString *)albumID
{
    if (!header && !albumID) {
        [_selectButton setAlpha:0.3];
        [_selectButton setUserInteractionEnabled:NO];
        return;
    }
    self.curAlbumID = albumID;
    [_selectButton setAlpha:1.f];
    [_selectButton setUserInteractionEnabled:YES];
}
- (void)uploadHeadershowCreateAlertView:(SCPUploadHeader *)header
{
    [_cells makeObjectsPerformSelector:@selector(descTextViewresignFirstResponder)];
}
#pragma mark -
#pragma mark keyboard delegate
- (SCPUploadCell *)getCellOfFirstResponder
{
    for (SCPUploadCell * cell in _cells) {
        if ([cell.descTextView isFirstResponder]) return cell;
    }
    return nil;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    offset = _uploadTableView.contentOffset;
    [_uploadHeader dismissAlbumChooseTable];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardHeight = keyboardSize.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _uploadTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.keyboardHeight);
    } completion:^(BOOL finished) {
        
    }];
    SCPUploadCell * cell = [self getCellOfFirstResponder];
    if (cell) {
        NSIndexPath * path = [_uploadTableView indexPathForCell:cell];
        [_uploadTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _uploadTableView.frame = self.view.bounds;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_uploadTableView setContentOffset:offset animated:NO];
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -
#pragma mark tableViewDelegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    switch (row) {
        case 0:
            return _uploadHeader;
        case 1:
            return _descCell;
        default:
            return [_cells objectAtIndex:row - 2];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells.count + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    switch (row) {
        case 0:
            return 170;
        case 1:
            return _descCell.frame.size.height + 8;
        default:
            return ((SCPUploadCell *) [_cells objectAtIndex:row - 2]).frame.size.height + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponderForAll];
}

#pragma mark
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_uploadHeader dismissAlbumChooseTable];
}

@end
