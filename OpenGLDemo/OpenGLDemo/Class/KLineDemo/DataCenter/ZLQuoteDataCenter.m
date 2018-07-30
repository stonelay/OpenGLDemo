//
//  ZLQuoteDataCenter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLQuoteDataCenter.h"
#import "MockServer.h"

@interface ZLQuoteDataCenter()

@end

@implementation ZLQuoteDataCenter

+ (instancetype)shareInstance {
    static ZLQuoteDataCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZLQuoteDataCenter alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadHisData];
    }
    return self;
}

- (void)loadHisData {
    self.hisKLineDataArray = [[MockServer getMockHisData] mutableCopy];
}

#pragma mark - property


@end




