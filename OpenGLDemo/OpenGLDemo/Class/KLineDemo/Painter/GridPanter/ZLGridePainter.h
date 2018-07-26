//
//  ZLGridePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLBasePainter.h"

@interface ZLGridePainter : ZLBasePainter

@property (nonatomic, strong) CAShapeLayer *longitudeLayer;
@property (nonatomic, strong) CAShapeLayer *latitudeLayer;

- (void)drawLatitudeLines;
- (void)drawLongittueLines;

@end
