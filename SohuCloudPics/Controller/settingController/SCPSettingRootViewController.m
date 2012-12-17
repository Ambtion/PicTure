//
//  SCPSettingRootViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "SCPSettingRootViewController.h"
#import "MySettingCell.h"
#import "SCPLoginPridictive.h"

static NSString* SettingMenu[7] = {@"个人资料设置",@"隐私和推送设置",@"清除缓冲",@"意见反馈",@"检查更新",@"关于",@"登出账号"};
static NSString* SettingCover[7] = {@"settings_user.png",@"settings_push.png",@"settings_feedback.png",
                                @"settings_feedback.png",@"settings_refresh.png",@"settings_about.png",@"settings_logout.png"};

static BOOL SettingNext[7] = {YES,YES,NO,YES,NO,YES,NO};
@implementation SCPSettingRootViewController

- (id)initwithController:(id)controller
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    //custimize iteam
   
    
    
}
- (void)_backbutton:(UIButton*)button
{
    NSLog(@"backbutton");
    [_controller dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark dataSouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BG_CELL"];
        if (cell ==  nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BG_CELL"] autorelease];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(8, 8, 28, 28);
            [button setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"header_back_press.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(_backbutton:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * bg_view = [[[UIImageView alloc] initWithFrame:CGRectMake(110, 55 , 100, 24)] autorelease];
            bg_view.image = [UIImage imageNamed:@"title_settings.png"];
            [cell.contentView addSubview:bg_view];
            [cell.contentView addSubview:button];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    MySettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[[MySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"] autorelease];
       
    }
    cell.c_ImageView.image = [UIImage imageNamed:SettingCover[indexPath.row - 1]];
    cell.c_Label.text = SettingMenu[indexPath.row - 1];
    
    if (SettingNext[indexPath.row - 1]) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryImage.image = [UIImage imageNamed:@"settings_arrow.png"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 55;
}
#pragma mark -
#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.row == 7) {
//        [SCPLoginPridictive removeDataForKey:nil];
        [SCPLoginPridictive logout];
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"已登出" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
