//
//  ZLGuideModel.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/30.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLGuideModel : NSObject

@property(nonatomic, assign) double     data;
@property(nonatomic, assign) NSInteger  cycle;

@property(nonatomic, assign) int        width;      //宽度, BOLL用

@property(nonatomic, assign) double     af;         //加速因子，SAR用
@property(nonatomic, assign) double     max;        //最大值，SAR用
@property(nonatomic, assign) Boolean    riseNotFall;//SAR用

@property(nonatomic, strong, readonly) NSString * name;
@property(nonatomic, strong) NSString * gid;
@property(nonatomic, strong) NSDate   * dataTime;


- (id)initWithId:(NSString *)gid;

@end
