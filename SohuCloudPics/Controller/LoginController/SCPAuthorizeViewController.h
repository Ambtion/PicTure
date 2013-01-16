//
//  SCPAuthorizeViewController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-8.
//
//

#import <UIKit/UIKit.h>
#import "SCPAlert_WaitView.h"

#import "URLLibaray.h"

typedef enum{
    LoginModelSina = 0,
    LoginModelQQ,
    LoginModelRenRen
}LoginModel;
@protocol SCPAuthorizeViewControllerDelegate <NSObject>
- (void)loginSucessInfo:(NSDictionary *)dic;
- (void)loginFailture:(NSString *)error;

@end
@interface SCPAuthorizeViewController : UIViewController<UIWebViewDelegate>
{
    SCPAlert_WaitView * _alterView;
    id controller;
    NSString * code;
}
@property(nonatomic,assign)id<SCPAuthorizeViewControllerDelegate> delegate;
- (id)initWithMode:(LoginModel)loginMode controller:(id)Acontroller;
@end
