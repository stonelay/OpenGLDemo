//
//  UserInfo.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/21.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_account forKey:@"account"];
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_userToken forKey:@"userToken"];
    [aCoder encodeObject:_lastYD forKey:@"lastYD"];
    
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeObject:_sign forKey:@"sign"];
    [aCoder encodeObject:_gender forKey:@"gender"];
//    [aCoder encodeObject:_account forKey:@"account"];
//    [aCoder encodeBool:_isLogin forKey:@"isLogin"];
    [aCoder encodeObject:_extraProperties forKey:@"extraProperties"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.account= [aDecoder decodeObjectForKey:@"account"];
        self.id     = [aDecoder decodeObjectForKey:@"id"];
        self.userToken= [aDecoder decodeObjectForKey:@"userToken"];
        self.lastYD = [aDecoder decodeObjectForKey:@"lastYD"];
        
        self.phone  = [aDecoder decodeObjectForKey:@"phone"];
        self.name   = [aDecoder decodeObjectForKey:@"name"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.sign   = [aDecoder decodeObjectForKey:@"sign"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
//        self.account = [aDecoder decodeObjectForKey:@"account"];
//        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
        self.extraProperties = [aDecoder decodeObjectForKey:@"extraProperties"];
    }
    return self;
}

@end
