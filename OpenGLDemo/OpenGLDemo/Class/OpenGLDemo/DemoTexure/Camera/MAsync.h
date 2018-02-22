//
//  MAsync.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

void runAsync(void (^block)(void));

@interface MAsync : NSObject

+ (instancetype)share;

@end
