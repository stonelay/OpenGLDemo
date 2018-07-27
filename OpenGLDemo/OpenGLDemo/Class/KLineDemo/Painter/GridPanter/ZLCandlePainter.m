//
//  ZLCandlePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLCandlePainter.h"
#import "KLineModel.h"

#import "SceneCandleModel.h"
#import "SceneCrossModel.h"

//#define UninitializedIndex   -1

#define UpColor         ZLHEXCOLOR(0xDC143C)
#define DownColor       ZLHEXCOLOR(0x47D3D1)
#define NormalColor     ZLHEXCOLOR(0xFAFAD2)
#define CrossColor      ZLHEXCOLOR(0x333333)

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
     
    NSArray *curShowArray = [self.dataSource showArrayInPainter:self];
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = curShowArray.count;
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    [curShowArray enumerateObjectsUsingBlock:^(KLineModel *model, NSUInteger idx, BOOL *stop) {
        CGFloat openY   = (sHigherPrice - model.open) / unitValue;
        CGFloat highY   = (sHigherPrice - model.high) / unitValue;
        CGFloat lowY    = (sHigherPrice - model.low) / unitValue;
        CGFloat closeY  = (sHigherPrice - model.close) / unitValue;
        
        CGFloat leftX = cellWidth * idx; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - idx) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        CAShapeLayer *cellShapeLayer = [self getCandleLayerFromOpenY:openY highY:highY lowY:lowY closeY:closeY leftX:leftX cellW:cellWidth];
        [self.candleShapeLayer addSublayer:cellShapeLayer];
    }];

    [self p_addSublayer:self.candleShapeLayer];
}

- (void)drawTrackingCross {
    [self releaseTrackingCrossLayer];
    
    CGPoint longPressPoint = [self.dataSource longPressPointInPainter:self];
    if (CGPointEqualToPoint(longPressPoint, CGPointZero)) {
        ZLErrorLog(@"不对 CGPointZero 绘制");
        return;
    }
    
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    NSInteger showCount = [self.dataSource showNumberInPainter:self];
    
    NSInteger crossIndex = longPressPoint.x / cellWidth;
    CGFloat leftX = cellWidth * crossIndex;
    
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    if (isShowArray) {
        NSInteger resIndex = (self.p_width - longPressPoint.x) / cellWidth;
        if (resIndex > showCount) {
            ZLErrorLog(@"超出绘制范围");
            return;
        }
        crossIndex = showCount - resIndex;
        leftX = self.p_width - resIndex * cellWidth;
    }
    
    if (crossIndex < 0) return;
    if (crossIndex > showCount - 1) return;

    //    NSUInteger crossIndex = [self.dataSource selectCrossIndexInPainter:self];
    KLineModel *model = [self.dataSource painter:self dataAtIndex:crossIndex];
    
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    
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
    
    [self p_addSublayer:self.trackingCrosslayer];
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
        _candleShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    }
    return _candleShapeLayer;
}

- (CAShapeLayer *)trackingCrosslayer {
    if (!_trackingCrosslayer) {
        _trackingCrosslayer = [CAShapeLayer layer];
        _trackingCrosslayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
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
    cellCAShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
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
    crossCAShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
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
