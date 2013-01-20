//
//  HomeBackContainer.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-21.
//
//

#import "HomeBackContainer.h"
#import "SCPAppDelegate.h"
#import "SCPLoginPridictive.h"

static NSString * IMAGENAME[4]  = {@"user_bg_plain.png",
    @"user_bg_sea.png",
    @"user_bg_soul.png",@"user_bg_stra.png"};
static NSString * ICON[4] = {@"user_icon_plain.png",@"user_icon_sea.png",@"user_icon_soul.png",@"user_icon_stra.png"};
@implementation HomeBackContainer
@synthesize delegate;
- (void)dealloc
{
    [_boxViews release];
    [super dealloc];
}
- (id)initWithDelegate:(id<HomeBackContainerDelegate>) Adelegete
{
    if (self = [super init]) {
        self.delegate = Adelegete;
        self.frame = [[UIScreen mainScreen] bounds];
        self.image = [UIImage imageNamed:@"pop_bg.png"];
        UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)] autorelease];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        [self addSubviews];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) return NO;
    return YES;
}

- (void)addSubviews
{
    _boxViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 162)];
    _boxViews.backgroundColor = [UIColor clearColor];
    _boxViews.image = [UIImage imageNamed:@"ueser_image_change_bg.png"];
    [self addSubview:_boxViews];
    [_boxViews setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [self boxviewaddSubViews];
}
- (void)boxviewaddSubViews
{
    for (int i = 0; i < 4; i++) {
        UIImageView * imageview = [[[UIImageView alloc] initWithFrame:CGRectMake(4 + 79 * i, 33, 77, 77)] autorelease];
        imageview.image = [UIImage imageNamed:ICON[i]];
        [imageview setUserInteractionEnabled:YES];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"user_image_check.png"] forState:UIControlStateSelected];
        button.frame = CGRectMake(4 + 79 * i, 33, 77, 77);
        button.center = imageview.center;
        button.tag = i + 1000;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_boxViews addSubview:imageview];
        [_boxViews addSubview:button];
    }
    [self setSelecteStateonButton];
}
- (void)tapGestureHandle:(id)gesture
{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _boxViews.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 120);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setSelecteStateonButton
{
    for (id  button in _boxViews.subviews){
        if ([button isKindOfClass:[UIButton class]])
            [button setSelected:NO];
    }
    NSInteger index = [self getSelectedImage];
    UIButton * button = (UIButton*)[_boxViews viewWithTag:index];
    [button setSelected:YES];
}

- (void)buttonClick:(UIButton *)button
{
    NSString * bgName = IMAGENAME[button.tag - 1000];
    if ([delegate respondsToSelector:@selector(homeBackContainerSeleced:)]){
        [delegate performSelector:@selector(homeBackContainerSeleced:) withObject:[UIImage imageNamed:bgName]];
        [self memoryBackImageWithName:bgName];
        [self setSelecteStateonButton];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _boxViews.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 120);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)memoryBackImageWithName:(NSString *)name
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([name isEqualToString:@""]) {
//        [userDefault removeObjectForKey:@"HomeBackImage"];
    }else{
        NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:[SCPLoginPridictive currentUserId]]];
        if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userinfo setValue:name forKey:@"HomeBackImage"];
        [userDefault setObject:userinfo forKey:[SCPLoginPridictive currentUserId]];
    }
    [userDefault synchronize];
}
- (NSInteger)getSelectedImage
{
    
    NSDictionary * userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:[SCPLoginPridictive currentUserId]];
    NSString * str = [userinfo objectForKey:@"HomeBackImage"];
    if (!str || [str isEqualToString:@""])       return 1002;
    for (int i = 0; i < 4; i++)
        if([IMAGENAME[i] isEqualToString:str]) return 1000 + i;
    return 1002;
}
- (void)show
{
    SCPAppDelegate * appDelegate = (SCPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _boxViews.frame = CGRectMake(0, self.bounds.size.height - 120, self.bounds.size.width, 120);
    } completion:^(BOOL finished) {
        [_boxViews setUserInteractionEnabled:YES];
    }];
    
}
@end
