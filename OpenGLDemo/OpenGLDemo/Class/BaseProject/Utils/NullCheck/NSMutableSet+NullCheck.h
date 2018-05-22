//
//  NSMutableSet+NullCheck.h
//  CF
//
//  Created by LayZhang on 2017/11/30.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (NullCheck)

- (void)addSafeObject:(id)anObject;

@end
