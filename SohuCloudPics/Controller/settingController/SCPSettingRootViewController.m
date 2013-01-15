//
//  SCPSettingRootViewController.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "SCPMenuNavigationController.h"
#import "SCPMainTabController.h"

#import "SCPSettingRootViewController.h"

#import "MySettingCell.h"
#import "SCPLoginPridictive.h"
#import "SCPSettingUserinfoController.h"
#import "SCPAboutController.h"
#import "SCPFeedBackController.h"
#import "ImageQualitySwitch.h"
#import "JSON.h"
//#define BASICURL_V1 @"http://10.10.68.104:8888/api/v1"

#define BASICURL_V1 @"http://dev.pp.sohu.com/api/v1"

static NSString* SettingMenu[7] = {@"个人资料设置",@"上传图片质量",@"清除缓存",@"意见反馈",@"检查更新",@"关于",@"登出账号"};
static NSString* SettingCover[7] = {@"settings_user.png",@"settings_push.png",@"settings_clear.png",
                                @"settings_feedback.png",@"settings_refresh.png",@"settings_about.png",@"settings_logout.png"};

static BOOL SettingNext[7] = {YES,NO,NO,YES,NO,YES,NO};
static BOOL SwitchShow[7] = {NO,YES,NO,NO,NO,NO,NO};

@implementation SCPSettingRootViewController

- (id)initwithController:(id)controller
{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}
- (void)dealloc
{
    [_tableView release];
    [loginView release];
    [cacheView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    [self.view addSubview:_tableView];
    //custimize iteam
}
- (void)_backbutton:(UIButton*)button
{
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
            button.frame = CGRectMake(5, 2, 35, 35);
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
    if (SettingNext[indexPath.row - 1])
        cell.accessoryImage.image = [UIImage imageNamed:@"settings_arrow.png"];
    
    if (SwitchShow[indexPath.row - 1]) {
        cell.imageSwitch = [[[ImageQualitySwitch alloc] initWithFrame:CGRectMake(320 - 90 - 5, (55 - 27)/2, 0, 0)] autorelease];
        [cell.contentView addSubview:cell.imageSwitch];
    }else{
        [cell.imageSwitch setHidden:YES];
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
    if (indexPath.row == 1 ) {//个人信息修改
        [self.navigationController pushViewController:[[[SCPSettingUserinfoController alloc] init] autorelease] animated:YES];
    }
    if (indexPath.row == 3) { //清除缓存
        cacheView = [[SCPAlertView_LoginTip alloc] initWithTitle:@"确认清除缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [cacheView show];
    }
    if (indexPath.row == 4) {
        [self.navigationController pushViewController:[[[SCPFeedBackController alloc] init] autorelease] animated:YES];
    }
    if (indexPath.row == 5) {
        [self onCheckVersion];
    }
    if (indexPath.row == 6) {//关于
        [self.navigationController pushViewController:[[[SCPAboutController alloc] init] autorelease] animated:YES];
    }
    if (indexPath.row == 7) {//
        loginView = [[SCPAlertView_LoginTip alloc] initWithTitle:@"确定要登出吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [loginView show];
    }
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSNumber *currentVersion = [infoDic objectForKey:@"versionCode"];
    NSString *URL =[NSString stringWithFormat:@"%@/version?app=ios",BASICURL_V1];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *dic = [results JSONValue];
    NSNumber * newVersion = [dic objectForKey:@"versionCode"];
    BOOL isUpata = [self CompareVersionFromOldVersion:currentVersion newVersion:newVersion];
    if (isUpata) {
        NSLog(@"%@",[dic allKeys]);
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:[dic objectForKey:@"updateURL"]]];
    }else{
        SCPAlert_CustomeView * tip = [[SCPAlert_CustomeView alloc] initWithTitle:@"当前已是最新版本"];
        [tip show];
        [tip release];
    }
}
-(BOOL)CompareVersionFromOldVersion : (NSNumber *)oldVersion newVersion : (NSNumber *)newVersion
{
    return ([oldVersion intValue] < [newVersion intValue]);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (loginView == alertView && buttonIndex == 1) {
        [SCPLoginPridictive logout];
        [self removeCacheAlluserInfo:YES];
        SCPMenuNavigationController * mnv = (SCPMenuNavigationController *)_controller;
        [mnv popToRootViewControllerAnimated:NO];
        
        SCPMainTabController * mainTab = [[mnv childViewControllers] lastObject];
        mainTab.selectedIndex = 0;
        [_controller dismissModalViewControllerAnimated:YES];
    }
    if (cacheView == alertView && buttonIndex == 1) {
        NSFileManager * manager  = [NSFileManager defaultManager];
        NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
        NSError * error = nil;
        [manager removeItemAtPath:str error:&error];
        if (error) NSLog(@"error::%@",error);
        [self removeCacheAlluserInfo:NO];
    }
}
- (void)removeCacheAlluserInfo:(BOOL)isRemove
{
    
    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [dic  objectForKey: @"CFBundleIdentifier"];
    NSUserDefaults *appUserDefaults = [[[NSUserDefaults alloc] init] autorelease];
    NSDictionary * cacheDic = [appUserDefaults persistentDomainForName: bundleId];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * _use_id = nil;
    NSString * _use_token = nil;
    NSNumber * GuideViewShowed = nil;
    NSNumber * FunctionShowed = nil;
    NSNumber * JPEG = nil;
    //read
    if ([defaults objectForKey:@"__USER_ID__"])
        _use_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"__USER_ID__"]];
    if ([defaults objectForKey:@"__USER_TOKEN__"])
        _use_token = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"__USER_TOKEN__"]];
    if ([defaults objectForKey:@"GuideViewShowed"])
        GuideViewShowed = [[[defaults objectForKey:@"GuideViewShowed"] copy] autorelease];
    if ([defaults objectForKey:@"FunctionShowed"])
        FunctionShowed = [[[defaults objectForKey:@"FunctionShowed"] copy] autorelease];
    if ([defaults objectForKey:@"JPEG"]) {
        JPEG = [[[defaults objectForKey:@"JPEG"] copy] autorelease];
    }
    
    //remove
    for (NSString * str in [cacheDic allKeys])
        [defaults removeObjectForKey:str];
    if (_use_id)
        [defaults setObject:_use_id forKey:@"__USER_ID__"];
    if (_use_token)
        [defaults setObject:_use_token forKey:@"__USER_TOKEN__"];
    if (GuideViewShowed)
        [defaults setObject:GuideViewShowed forKey:@"GuideViewShowed"];
    if (FunctionShowed)
        [defaults setObject:FunctionShowed forKey:@"FunctionShowed"];
    if (isRemove) {
        
    }else{
        if (JPEG)
            [defaults setObject:JPEG forKey:@"JPEG"];

    }
    NSLog(@"%@",cacheDic);
    [defaults synchronize];
}

@end
