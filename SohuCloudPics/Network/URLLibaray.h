//
//  URLLibaray.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-16.
//
//


//#define DEV 1


#ifdef DEV

#define BASICURL @"http://dev.pp.sohu.com"
#define BASICURL_V1 @"http://dev.pp.sohu.com/api/v1"

#else

#define BASICURL @"http://pp.sohu.com"
#define BASICURL_V1 @"http://pp.sohu.com/api/v1"

#endif

#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

#define CLIENT_SECRET @"47ae8860-2f8d-36c3-be99-3ebba8f1e7e7"

#define WEIBOOAUTHOR2URL @"https://api.weibo.com/oauth2/authorize?display=mobile&response_type=code&redirect_uri=http://pp.sohu.com/users/auth/weibo/callback/aHR0cDovL3BwLnNvaHUuY29tLw!!&client_id=992243007"

#define QQOAUTHOR2URL  @"https://graph.qq.com/oauth2.0/authorize?scope=get_user_info&response_type=code&redirect_uri=http://pp.sohu.com/users/auth/qq/callback/aHR0cDovL3BwLnNvaHUuY29tLz91c2VySWQ9NDEz&client_id=100319476"

#define RENRENAUTHOR2URL @"https://graph.renren.com/oauth/authorize?response_type=code&redirect_uri=http://pp.sohu.com/users/auth/renren/callback&display=popup&client_id=ed8838c335d146319b6612a3026190ae"
