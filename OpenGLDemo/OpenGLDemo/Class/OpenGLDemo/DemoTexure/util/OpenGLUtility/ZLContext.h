//
//  ZLContext.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ContextInstance [ZLContext shareContext]

@interface ZLContext : NSObject
//@property (nonatomic, strong) EAGLContext *context;

+ (instancetype)shareContext;
+ (void)useContext;

@end
