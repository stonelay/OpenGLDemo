//
//  ZLGuideModel.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/30.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGuideModel.h"

@implementation ZLGuideModel

- (instancetype)init {
    if (self = [super init]) {
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithId:(NSString *)gid {
    if (self = [super init]) {
        [self initDefault];
        self.gid = gid;
    }
    return self;
}

- (void)initDefault {
    self.gid = @"";
    self.dataTime = nil;
    self.data = 0.0;
    self.cycle = 0;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %ld", self.gid, (long)self.cycle];
}

@end
