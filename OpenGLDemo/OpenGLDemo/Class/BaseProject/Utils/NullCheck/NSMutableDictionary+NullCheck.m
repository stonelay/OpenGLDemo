//
//  NSMutableDictionary+NullCheck.m
//  CF
//
//  Created by LayZhang on 2017/11/30.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "NSMutableDictionary+NullCheck.h"

@implementation NSMutableDictionary (NullCheck)

- (void)setSafeObject:(id)anObject forKey:(id)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
