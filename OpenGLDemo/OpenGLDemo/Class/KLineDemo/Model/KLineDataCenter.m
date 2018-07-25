//
//  KLineDataCenter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "KLineDataCenter.h"
#import "MockServer.h"

@implementation KLineDataCenter

+ (instancetype)shareInstance {
    static KLineDataCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KLineDataCenter alloc] init];
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

//- (NSMutableArray *)hisKLineData {
//    if (!_hisKLineData) {
//        _hisKLineData = [[NSMutableArray alloc] init];
//    }
//    return _hisKLineData;
//}


@end




