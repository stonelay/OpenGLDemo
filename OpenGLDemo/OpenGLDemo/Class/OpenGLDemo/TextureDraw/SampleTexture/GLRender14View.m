//
//  GLRender14View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/15.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender14View.h"

@implementation GLRender14View

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化属性
        NSLog(@"init frame.....");
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // 1. 获取当前控件的图形上下文
    // CG:表示这个类在CoreGraphics框架里  Ref:引用
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 原始方式 绘制
    //         2. 描述绘画内容
    //         a. 创建图形起始点
    CGContextMoveToPoint(context, 20, 50);
    //         b. 添加图形的终点
    CGContextAddLineToPoint(context, 200, 150);
    CGContextAddLineToPoint(context, 200, 55);

    /*
     // 上下文方式绘制
     // 2. 描述绘画内容
     //    a. 创建图形路径
     CGMutablePathRef path = CGPathCreateMutable();
     //    b. 创建图形起始点
     CGPathMoveToPoint(path, NULL, 50, 50);
     //    c. 添加图形的终点
     CGPathAddLineToPoint(path, NULL, 200, 50);
     */
    
    // 3. 把绘画内容添加到图形上下文
//    CGContextAddPath(context, path);

    // 4. 设置图形上下文的状态（线宽、颜色等）
    CGContextSetLineWidth(context, 5);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);

    // 5. 渲染图形上下文
    CGContextStrokePath(context);
    
    
    CGContextAddLineToPoint(context, 200, 155);
    CGContextStrokePath(context);
}

// bezier 曲线绘制
//- (void)drawRect:(CGRect)rect {
//    // 1. 创建贝瑟尔路径
//    UIBezierPath *path = [UIBezierPath bezierPath];
//
//    // 2. 设置起点
//    [path moveToPoint:CGPointMake(20, 20)];
//
//    // 3. 设置终点
//    [path addLineToPoint:CGPointMake(80, 150)];
//
//    // 4. 设置路径状态
//    // 设置颜色
//    [[UIColor redColor] set];
//    [path setLineWidth:5];// 设置线宽
//
//    // 5. 绘制路径
//    [path stroke];
//
//
//    // 1. 创建贝瑟尔路径
//    UIBezierPath *path1 = [UIBezierPath bezierPath];
//
//    // 2. 设置起点
//    [path1 moveToPoint:CGPointMake(50, 20)];
//
//    // 3. 设置拐点
//    [path1 addLineToPoint:CGPointMake(200, 100)];
//
//    // 3. 设置终点
//    [path1 addLineToPoint:CGPointMake(50, 230)];
//
//    // 4. 设置路径状态
//    // 设置颜色
//    [[UIColor blueColor] set];
//    // 设置线宽
//    [path1 setLineWidth:15];
//    // 设置连接样式
//    [path1 setLineJoinStyle:kCGLineJoinRound];
//    // 设置顶角样式
//    [path1 setLineCapStyle:kCGLineCapRound];
//
//    // 4. 绘制路径
//    [path1 stroke];
//
//}

@end
