//
//  DrawModel.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/6.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "DrawModel.h"

@implementation DrawModel

@end

@implementation LineModel

+ (instancetype)lineWithBeginPoint:(CGPoint)beginPoint endPoint:(CGPoint)endPoint {
    LineModel *model = [[LineModel alloc] init];
    model.beginPoint = beginPoint;
    model.endPoint = endPoint;
    return model;
}
@end

@implementation DrawElement
@end
