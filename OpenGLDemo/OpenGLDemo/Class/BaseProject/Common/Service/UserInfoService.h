//
//  UserInfoService.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

//#define TESTID @"D60A0296-36F2-4A1A-9B6C-3FBBB6C144E6"

//#define TESTID @"57af3b7b03ce47318239b718e4ebb06e"


@interface UserInfoService : NSObject

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, assign) BOOL isLastYD;

+ (instancetype)shareUserInfo;

- (BOOL)isLogin;
- (void)doLogin;

- (void)saveData;
- (void)clearData;
- (void)logoutAndClearData;
- (void)loginAndSaveData;

@end
