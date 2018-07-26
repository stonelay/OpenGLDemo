//
//  ZLGridePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGridePainter.h"

#define BorderStrokeColor       ZLHEXCOLOR(0x222222)
#define AxisStrokeColor         ZLHEXCOLOR(0x999999)
#define LongitudeStrokeColor    ZLHEXCOLOR(0xC71585)
#define LatitudeStrokeColor     ZLHEXCOLOR(0xC71585)

@interface ZLGridePainter()

@property (nonatomic, strong) CAShapeLayer *borderShapeLayer;
@property (nonatomic, strong) CAShapeLayer *xAxisShapeLayer;


@end

@implementation ZLGridePainter

- (void)p_initDefault {
    [super p_initDefault];
    self.borderShapeLayer.strokeColor = BorderStrokeColor.CGColor;
    self.xAxisShapeLayer.strokeColor = AxisStrokeColor.CGColor;
    self.latitudeLayer.strokeColor = LatitudeStrokeColor.CGColor;
    self.longitudeLayer.strokeColor = LongitudeStrokeColor.CGColor;
}

#pragma mark - override
- (void)draw {
    [super draw];
    
    [self drawBorder];
    [self drawAxis];
    [self drawLongittueLines];
    [self drawLatitudeLines];
}

- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {}
- (void)panEndedPoint:(CGPoint)point {}

#pragma mark - draw
- (void)drawBorder {
    CGRect border = self.p_bounds;
    border.size.height += self.bMargin;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:border];
    self.borderShapeLayer.path = path.CGPath;
    [self p_addSublayer:self.borderShapeLayer];
}

- (void)drawAxis {
    CGPoint pointXBegin = CGPointMake(0, self.p_height);
    CGPoint pointXEnd = CGPointMake(self.p_width, self.p_height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointXBegin];
    [path addLineToPoint:pointXEnd];
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    self.xAxisShapeLayer.path = path.CGPath;
    
    [path removeAllPoints];
    [self p_addSublayer:self.xAxisShapeLayer];
}

- (void)drawLatitudeLines {
    // 当前场景 不适合 在这绘制
    // noop
}

- (void)drawLongittueLines {
    // 当前场景 不适合 在这绘制
    // noop
}

- (void)releaseBorderShapeLayer{
    if (self.borderShapeLayer) {
        [self.borderShapeLayer removeFromSuperlayer];
        self.borderShapeLayer = nil;
    }
}

- (void)releaseXAxisShapeLayer {
    if (self.xAxisShapeLayer) {
        [self.xAxisShapeLayer removeFromSuperlayer];
        self.xAxisShapeLayer = nil;
    }
}

- (void)releaseLongitudeLayer {
    if (self.longitudeLayer) {
        [self.longitudeLayer removeFromSuperlayer];
        self.longitudeLayer = nil;
    }
}

- (void)releaseLatitudeLayer {
    if (self.latitudeLayer) {
        [self.latitudeLayer removeFromSuperlayer];
        self.latitudeLayer = nil;
    }
}

#pragma mark - property
- (CAShapeLayer *)borderShapeLayer {
    if (!_borderShapeLayer) {
        _borderShapeLayer = [CAShapeLayer layer];
        _borderShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _borderShapeLayer.fillColor = ZLClearColor.CGColor;
        _borderShapeLayer.lineWidth = LINEWIDTH;
    }
    return _borderShapeLayer;
}

- (CAShapeLayer *)xAxisShapeLayer {
    if (!_xAxisShapeLayer) {
        _xAxisShapeLayer = [CAShapeLayer layer];
        _xAxisShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _xAxisShapeLayer.fillColor = ZLClearColor.CGColor;
        _xAxisShapeLayer.lineWidth = LINEWIDTH;
    }
    return _xAxisShapeLayer;
}

- (CAShapeLayer *)longitudeLayer {
    if (!_longitudeLayer) {
        _longitudeLayer = [CAShapeLayer layer];
        _longitudeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _longitudeLayer.fillColor = ZLClearColor.CGColor;
        _longitudeLayer.lineWidth = LINEWIDTH;
    }
    return _longitudeLayer;
}

- (CAShapeLayer *)latitudeLayer {
    if (!_latitudeLayer) {
        _latitudeLayer = [CAShapeLayer layer];
        _latitudeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _latitudeLayer.fillColor = ZLClearColor.CGColor;
        _latitudeLayer.lineWidth = LINEWIDTH;
    }
    return _latitudeLayer;
}

- (void)p_clear {
    [self releaseBorderShapeLayer];
    [self releaseXAxisShapeLayer];
    [self releaseLatitudeLayer];
    [self releaseLongitudeLayer];
}


@end
