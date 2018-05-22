//
//  NSURL+ZLEX.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ZLEX)

@property (nonatomic, strong) NSDictionary *parameters;

+ (NSURL *)queryWithBase:(NSString *)base queryElements:(NSDictionary *)queryElements;

- (void)scanParameters;
- (id)objectForKeyedSubscript:(id)key;
- (NSString *)parameterForKey:(NSString *)key;

@end
