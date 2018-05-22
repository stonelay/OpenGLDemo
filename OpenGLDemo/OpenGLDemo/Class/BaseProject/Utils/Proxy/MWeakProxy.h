//
//  MWeakProxy.h
//  Caifuguanjia
//
//  Created by LayZhang on 2017/12/11.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用来 解除 循环引用
 */
@interface MWeakProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

@end
