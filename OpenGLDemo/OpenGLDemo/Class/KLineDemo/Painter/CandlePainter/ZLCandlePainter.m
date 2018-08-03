//
//  ZLCandlePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLCandlePainter.h"
#import "KLineModel.h"

//#define UninitializedIndex   -1

#define UpColor         ZLHEXCOLOR(0xDC143C)
#define DownColor       ZLHEXCOLOR(0x47D3D1)
#define NormalColor     ZLHEXCOLOR(0xFAFAD2)
#define CrossColor      ZLHEXCOLOR(0xbebebe)

@interface ZLCandlePainter() {
    UIColor *_uColor; // 涨
    UIColor *_dColor; // 跌
    UIColor *_nColor; // 平
}

@property (nonatomic, strong) CAShapeLayer *candleShapeLayer;  // 蜡烛线
@property (nonatomic, strong) CAShapeLayer *trackingCrosslayer;// 十字线

@end

@implementation ZLCandlePainter

- (void)p_initDefault {
    [super p_initDefault];
    
    _uColor = UpColor;
    _dColor = DownColor;
    _nColor = NormalColor;
}

#pragma mark - override
- (void)draw {
    [super draw];
    
    [self drawCandle];
}

// tap
- (void)tapAtPoint:(CGPoint)point {}

// pan
- (void)panBeganPoint:(CGPoint)point {}

- (void)panChangedPoint:(CGPoint)point {
    [self drawCandle];
}

- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}

- (void)pinchChangedScale:(CGFloat)scale {
    [self drawCandle];
}

- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    [self drawTrackingCross];
}

- (void)longPressChangedLocation:(CGPoint)location {
    [self drawTrackingCross];
}

- (void)longPressEndedLocation:(CGPoint)location {
    [self releaseTrackingCrossLayer];
}

#pragma mark - draw
- (void)drawCandle {
    [self releaseCandleShapeLayer];
    [self p_addSublayer:self.candleShapeLayer];

    NSArray *curShowArray = [self.dataSource showArrayInPainter:self];
    CGFloat sHigherPrice = [self.delegate sHigherPriceInPainter:self];
//    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat unitValue = [self.delegate painter:self sunitByDValue:self.p_height];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    CGFloat firstCandleX = [self.dataSource firstCandleXInPainter:self];
    
    [curShowArray enumerateObjectsUsingBlock:^(KLineModel *model, NSUInteger idx, BOOL *stop) {
        CGFloat openY   = (sHigherPrice - model.open) / unitValue;
        CGFloat highY   = (sHigherPrice - model.high) / unitValue;
        CGFloat lowY    = (sHigherPrice - model.low) / unitValue;
        CGFloat closeY  = (sHigherPrice - model.close) / unitValue;
        CGFloat leftX   = firstCandleX + cellWidth * idx;
        CAShapeLayer *cellShapeLayer = [self getCandleLayerFromOpenY:openY highY:highY lowY:lowY closeY:closeY leftX:leftX cellW:cellWidth];
        [self.candleShapeLayer addSublayer:cellShapeLayer];
    }];
}

- (void)drawTrackingCross {
    [self releaseTrackingCrossLayer];
    [self p_addSublayer:self.trackingCrosslayer];
    
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    NSInteger crossIndex = [self.dataSource longPressIndexInPainter:self];
    CGFloat firstCandleX = [self.dataSource firstCandleXInPainter:self];
    CGFloat leftX = firstCandleX + cellWidth * crossIndex;

    //    NSUInteger crossIndex = [self.dataSource selectCrossIndexInPainter:self];
    KLineModel *model = [self.dataSource painter:self dataAtIndex:crossIndex];
    
    CGFloat sHigherPrice = [self.delegate sHigherPriceInPainter:self];
//    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat unitValue = [self.delegate painter:self sunitByDValue:self.p_height];
    
    CGFloat openY   = (sHigherPrice - model.open) / unitValue;
    CGFloat highY   = (sHigherPrice - model.high) / unitValue;
    CGFloat lowY    = (sHigherPrice - model.low) / unitValue;
    //        CGFloat closeY  = (sHigherPrice - model.close) / unitValue;
    
    leftX += candleLeftAdge(cellWidth);
    CGPoint positionPoint = CGPointMake(leftX + candleWidth(cellWidth) / 2, openY);
    CGPoint ltPoint = CGPointMake(leftX, highY);
    CGPoint rbPoint = CGPointMake(leftX + candleWidth(cellWidth), lowY);
    CAShapeLayer *crossLayer = [self getTrackingCrossLayerFromCrossPoint:positionPoint ltPoint:ltPoint rbPoint:rbPoint];
    [self.trackingCrosslayer addSublayer:crossLayer];
}

#pragma mark - release
- (void)releaseCandleShapeLayer {
    if (_candleShapeLayer) {
        [_candleShapeLayer removeFromSuperlayer];
        _candleShapeLayer = nil;
    }
}

- (void)releaseTrackingCrossLayer {
    if (_trackingCrosslayer) {
        [_trackingCrosslayer removeFromSuperlayer];
        _trackingCrosslayer = nil;
    }
}
#pragma mark - property
- (CAShapeLayer *)candleShapeLayer {
    if (!_candleShapeLayer) {
        _candleShapeLayer = [CAShapeLayer layer];
        _candleShapeLayer.frame = self.p_frame;
    }
    return _candleShapeLayer;
}

- (CAShapeLayer *)trackingCrosslayer {
    if (!_trackingCrosslayer) {
        _trackingCrosslayer = [CAShapeLayer layer];
        _trackingCrosslayer.frame = self.p_frame;
    }
    return _trackingCrosslayer;
}

#pragma mark - sublayers
- (CAShapeLayer *)getCandleLayerFromOpenY:(CGFloat)openY highY:(CGFloat)highY lowY:(CGFloat)lowY closeY:(CGFloat)closeY leftX:(CGFloat)leftX cellW:(CGFloat)cellW {
    // bezier
    leftX += candleLeftAdge(cellW);
    CGFloat minY = MIN(openY, closeY);
    CGFloat height = MAX(fabs(closeY - openY), LINEWIDTH);
    CGRect rect = CGRectMake(leftX, minY, candleWidth(cellW), height);
    UIBezierPath *cellpath = [UIBezierPath bezierPathWithRect:rect];
    cellpath.lineWidth = LINEWIDTH;
    
    // 最高
    [cellpath moveToPoint:CGPointMake(leftX + candleWidth(cellW) / 2, minY)];
    [cellpath addLineToPoint:CGPointMake(leftX + candleWidth(cellW) / 2, highY)];
    
    // 最低
    [cellpath moveToPoint:CGPointMake(leftX + candleWidth(cellW) / 2, minY + height)];
    [cellpath addLineToPoint:CGPointMake(leftX + candleWidth(cellW) / 2, lowY)];
    
    CAShapeLayer *cellCAShapeLayer = [CAShapeLayer layer];
    cellCAShapeLayer.frame = self.p_bounds;
    cellCAShapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //调整颜色
    if (openY == closeY) {
        cellCAShapeLayer.strokeColor = _nColor.CGColor;
    }else if (openY > closeY){
        cellCAShapeLayer.strokeColor = _uColor.CGColor;
    }else{
        cellCAShapeLayer.strokeColor = _dColor.CGColor;
        cellCAShapeLayer.fillColor = _dColor.CGColor;
    }
    cellCAShapeLayer.path = cellpath.CGPath;
    
    [cellpath removeAllPoints];
    return cellCAShapeLayer;
}

- (CAShapeLayer *)getTrackingCrossLayerFromCrossPoint:(CGPoint)crossPoint ltPoint:(CGPoint)ltPoint rbPoint:(CGPoint)rbPoint {
    CGFloat adge = (rbPoint.x - ltPoint.x) / 4;
    
    CGFloat top = ltPoint.y - adge;
    CGFloat bottom = rbPoint.y + adge;
    CGFloat left = ltPoint.x - adge;
    CGFloat right = rbPoint.x + adge;
    CGFloat crossY = crossPoint.y;
    CGFloat crossX = crossPoint.x;
    
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    crossPath.lineCapStyle = kCGLineCapRound; //线条拐角
    crossPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    // xCross
    [crossPath moveToPoint:CGPointMake(0, crossY)];
    [crossPath addLineToPoint:CGPointMake(left, crossY)];
    [crossPath moveToPoint:CGPointMake(right, crossY)];
    [crossPath addLineToPoint:CGPointMake(self.p_width, crossY)];
    
    // yCross
    [crossPath moveToPoint:CGPointMake(crossX, 0)];
    [crossPath addLineToPoint:CGPointMake(crossX, top)];
    [crossPath moveToPoint:CGPointMake(crossX, bottom)];
    [crossPath addLineToPoint:CGPointMake(crossX, self.p_height)];
    
    CAShapeLayer *crossCAShapeLayer = [CAShapeLayer layer];
    crossCAShapeLayer.frame = self.p_bounds;
    crossCAShapeLayer.strokeColor = CrossColor.CGColor;
    
    crossCAShapeLayer.path = crossPath.CGPath;
    
    [crossPath removeAllPoints];
    return crossCAShapeLayer;
}

- (void)p_clear {
    [self releaseCandleShapeLayer];
    [self releaseTrackingCrossLayer];
}

@end
