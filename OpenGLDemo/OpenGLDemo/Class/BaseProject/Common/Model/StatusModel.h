//
//  StatusModel.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StatusCode) {
    StatusCodeNone                  = 0,
//    StatusCodeSuccess               = 1000000,
//    StatusCodeUnlogin               = 1002,
    
//    StatusCodeUnregistered          = 1003,
//    StatusCodeCaptchaCodeErr        = 1120, // 验证码 错误
    
    StatusCodeSuccess               = 200,
    StatusCodeUserExist             = 201, // 用户已存在
    
    // 内部定义
    StatusCodeFailed                = 404,
    
    // 不确定
    StatusCodeUnlogin               = 1002,
    StatusCodeUnregistered          = 1003,// code 还不确定
};

@interface StatusModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL  rel;
@property (nonatomic, strong) NSString *message;


@end
