//
//  SCPURLLibaray.h
//  SCPNetWork
//
//  Created by sohu on 12-11-19.
//  Copyright (c) 2012年 Qu. All rights reserved.
//

#define HOST        "10.10.79.134"

#define API_BASE    @"http://" HOST "/api"

//广场
#define URL_EXPLORE  API_BASE "/explore/all/"

//照片详细页: (注) 访问权限问题
#define URL_PHOTOINFO(use_id, photo_id)[NSString stringWithFormat:API_BASE"/u/%@/p%@", user_id,photo_id]

//个人关注页

#define URL_USERINFOFeed(user_id,page)  [NSString stringWithFormat:API_BASE"/u/%@/%d",user_id,page]
#define URL_USERINFO(user_id)  [NSString stringWithFormat:API_BASE"/u/%@",user_id]

#define URL_USERFEED API_BASE "/feed"
//个人页

//跟随
#define URL_USERFOLLOWERS(user_id, page)  [NSString stringWithFormat:API_BASE"/u/%@/followers/%d", user_id, page]
#define URL_USERFOLLOWINGS(user_id, page)  [NSString stringWithFormat:API_BASE"/u/%@/followings/%d", user_id, page]

#define URL_USERFOLDER(user_id)  [NSString stringWithFormat:API_BASE"/u/%@/folders", user_id]

