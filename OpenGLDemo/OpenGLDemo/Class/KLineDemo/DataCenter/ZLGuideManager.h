//
//  ZLGuideManager.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/27.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLGuideDataPack.h"

@interface ZLGuideManager : NSObject

- (void)updateWithChartData:(NSArray *)chartData;

- (ZLGuideDataPack *)getDataPackByMAKey:(NSString *)dataKey;

@end
