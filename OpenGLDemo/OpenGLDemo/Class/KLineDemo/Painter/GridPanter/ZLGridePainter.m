//
//  ZLGridePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGridePainter.h"

#define BorderStrokeColor       ZLHEXCOLOR(0x636363)
#define AxisStrokeColor         ZLHEXCOLOR(0x636363)
#define LongitudeStrokeColor    ZLHEXCOLOR(0xC71585)
#define LatitudeStrokeColor     ZLHEXCOLOR(0xC71585)

#define AxisMarginBottom (60 * SCALE)

@interface ZLGridePainter()

@property (nonatomic, strong) CAShapeLayer *borderShapeLayer;
@property (nonatomic, strong) CAShapeLayer *xAxisShapeLayer;

@property (nonatomic, strong) CAShapeLayer *longitudeLayer;
@property (nonatomic, strong) CAShapeLayer *latitudeLayer;

@end

@implementation ZLGridePainter

- (void)zl_initDefault {
    
}

- (void)draw {
    if (!self.p_havePaintView) {
        return;
    }
    [self drawBorder];
    [self drawAxis];
}

- (void)drawBorder {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.paintView.bounds];
    self.borderShapeLayer.path = path.CGPath;
    [self.paintView.layer addSublayer:self.borderShapeLayer];
}

- (void)drawAxis {
    CGPoint pointXBegin = CGPointMake(0, self.p_height - AxisMarginBottom);
    CGPoint pointXEnd = CGPointMake(self.p_width, self.p_height - AxisMarginBottom);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointXBegin];
    [path addLineToPoint:pointXEnd];
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    self.xAxisShapeLayer.path = path.CGPath;
    
    [self.paintView.layer addSublayer:self.xAxisShapeLayer];
}

- (void)drawLatitudeLines {}
- (void)drawLongittueLines {}

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
        _borderShapeLayer.strokeColor = BorderStrokeColor.CGColor;
        _borderShapeLayer.fillColor = ZLClearColor.CGColor;
        _borderShapeLayer.lineWidth = LINEWIDTH;
    }
    return _borderShapeLayer;
}

- (CAShapeLayer *)xAxisShapeLayer {
    if (!_xAxisShapeLayer) {
        _xAxisShapeLayer = [CAShapeLayer layer];
        _xAxisShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _xAxisShapeLayer.strokeColor = AxisStrokeColor.CGColor;
        _xAxisShapeLayer.fillColor = ZLClearColor.CGColor;
        _xAxisShapeLayer.lineWidth = LINEWIDTH;
    }
    return _xAxisShapeLayer;
}

- (CAShapeLayer *)longitudeLayer {
    if (!_longitudeLayer) {
        _longitudeLayer = [CAShapeLayer layer];
        _longitudeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _longitudeLayer.strokeColor = LongitudeStrokeColor.CGColor;
        _longitudeLayer.fillColor = ZLClearColor.CGColor;
        _longitudeLayer.lineWidth = LINEWIDTH;
    }
    return _longitudeLayer;
}

- (CAShapeLayer *)latitudeLayer {
    if (!_latitudeLayer) {
        _latitudeLayer = [CAShapeLayer layer];
        _latitudeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _latitudeLayer.strokeColor = LatitudeStrokeColor.CGColor;
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