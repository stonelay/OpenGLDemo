//
//  NSArray+NullCheck.m
//  CF
//
//  Created by LayZhang on 2017/11/30.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "NSArray+NullCheck.h"

@implementation NSArray (NullCheck)

- (id)safeObjectAtIndex:(NSInteger)index {
    id obj = nil;
    if (index < self.count) {
        obj = [self objectAtIndex:index];
    }
    return obj;
}

@end
