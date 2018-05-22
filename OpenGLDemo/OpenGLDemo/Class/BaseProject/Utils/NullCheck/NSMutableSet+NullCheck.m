//
//  NSMutableSet+NullCheck.m
//  CF
//
//  Created by LayZhang on 2017/11/30.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "NSMutableSet+NullCheck.h"

@implementation NSMutableSet (NullCheck)

- (void)addSafeObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

@end
