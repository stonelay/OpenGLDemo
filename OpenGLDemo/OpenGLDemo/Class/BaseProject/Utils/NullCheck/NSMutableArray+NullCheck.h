//
//  NSMutableArray+NullCheck.h
//  CF
//
//  Created by LayZhang on 2017/11/30.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NullCheck)

- (void)addSafeObject:(id)anObject;
- (void)insertSafeObject:(id)anObject atIndex:(NSUInteger)index;
- (id)objectAtSafeIndex:(NSUInteger)index;
- (void)addObjectsFromSafeArray:(NSArray *)otherArray;

@end
