//
//  UserInfoService.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "UserInfoService.h"

#define UserInfoFileName @"UserInfoFileName"

#define UserInfoDataKey @"UserInfoDataKey"

@interface UserInfoService()

@end

@implementation UserInfoService

+ (instancetype)shareUserInfo {
    static UserInfoService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoService alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *dataPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dataPath = [NSString stringWithFormat:@"%@/%@", dataPath, UserInfoFileName];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
    if (!dictionary) {
        return;
    }
    NSLog(@"%@", dictionary);
    
    UserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:dictionary[UserInfoDataKey]];
    if (!userInfo) {
        userInfo = [[UserInfo alloc] init];
    }
    self.userInfo = userInfo;
}

- (void)saveData {
    NSString *dataPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dataPath = [NSString stringWithFormat:@"%@/%@", dataPath, UserInfoFileName];
    //    NSMutableDictionary *dictPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:dataPath];
    
    NSMutableDictionary *dictPlist = [[NSMutableDictionary alloc] init];
    
    if (self.userInfo) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
        dictPlist[UserInfoDataKey] = data;
    }
    
    if(![dictPlist writeToFile:dataPath atomically:YES]){
        NSLog(@"write user config file failed.");
    }
}

- (void)clearData {
    _userInfo = [[UserInfo alloc] init];
    [self saveData];
    [DataCenter clearData];
}

- (void)logoutAndClearData {
    [self clearData];
    [DefaultNotificationCenter postNotificationName:kNotificationUserLogout object:nil];
}

- (void)loginAndSaveData {
    [self saveData];
    [DefaultNotificationCenter postNotificationName:kNotificationUserLogin object:nil];
}

- (BOOL)isLogin {
    if (self.userInfo && self.userInfo.id && self.userInfo.account) {
        return YES;
    }
    return NO;
}

- (void)doLogin {
    [[ZLNavigationService sharedService] openUrl:LocalAppHost(LoginHost)];
}

// 登录后才能请求
- (BOOL)isLastYD {
    if (![self isLogin]) {
        return NO;
    }
    NSString *currentYD = [DateFormat getCurrentYD];
    if ([currentYD isEqualToString:self.userInfo.lastYD]) {
        return NO;
    }
    self.userInfo.lastYD = currentYD;
    [self saveData];
    return YES;
}


@end
