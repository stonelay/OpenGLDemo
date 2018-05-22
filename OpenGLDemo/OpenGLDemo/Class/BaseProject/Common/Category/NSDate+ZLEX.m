//
//  NSDate+ZLEX.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/20.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "NSDate+ZLEX.h"

#define DayInterval (60 * 60 * 24)

@implementation NSDate (ZLEX)

- (NSInteger)dayFromNow {
    NSLog(@"%@  %@", self, [NSDate new]);
    NSTimeInterval delta = [self timeIntervalSinceDate:[NSDate new]];
    NSLog(@"%lf", delta);
    return delta / DayInterval + 1;
}

@end
