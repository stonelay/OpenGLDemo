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

@property (nonatomic, strong) SceneCandleModel *sceneCandleModel;
@property (nonatomic, strong) SceneCrossModel *sceneCrossModel;
@property (nonatomic, strong) NSArray *curShowArray;

@property (nonatomic, strong) CAShapeLayer *candleShapeLayer;  // 蜡烛线
@property (nonatomic, strong) CAShapeLayer *trackingCrosslayer;// 十字线

@end

@implementation ZLCandlePainter

- (void)p_initDefault {
    _uColor = UpColor;
    _dColor = DownColor;
    _nColor = NormalColor;
}

#pragma mark - override
- (void)draw {
    [super draw];
    
    [self updateCandleScene];
    [self updateCrossScene];
    [self updateCurShowArray];
    [self drawCandle];
}

- (void)updateCandleScene {
    if ([self.dataSource respondsToSelector:@selector(sceneCandleModelInpainter:)]) {
        self.sceneCandleModel = [self.dataSource sceneCandleModelInpainter:self];
    }
}

- (void)updateCrossScene {
    if ([self.dataSource respondsToSelector:@selector(sceneCrossModelInpainter:)]) {
        self.sceneCrossModel = [self.dataSource sceneCrossModelInpainter:self];
    }
}

- (void)updateCurShowArray {
    if ([self.dataSource respondsToSelector:@selector(showArrayInPainter:)]) {
        self.curShowArray = [self.dataSource showArrayInPainter:self];
    }
}

// pan
- (void)panBeganPoint:(CGPoint)point {}

- (void)panChangedPoint:(CGPoint)point {
    [self updateCandleScene];
    [self updateCurShowArray];
    [self drawCandle];
}

- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}

- (void)pinchChangedScale:(CGFloat)scale {
    [self updateCandleScene];
    [self updateCurShowArray];
    [self drawCandle];
}

- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    [self updateCrossScene];
    [self drawTrackingCross];
}

- (void)longPressChangedLocation:(CGPoint)location {
    [self updateCrossScene];
    [self drawTrackingCross];
}

- (void)longPressEndedLocation:(CGPoint)location {
    [self updateCrossScene];
    [self releaseTrackingCrossLayer];
}

#pragma mark - draw
- (void)drawCandle {
    [self releaseCandleShapeLayer];
    
    [self.curShowArray enumerateObjectsUsingBlock:^(KLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *cellCAShapeLayer = [self getCandleLayerFromModel:model Index:idx];
        [self.candleShapeLayer addSublayer:cellCAShapeLayer];
    }];

    [self p_addSublayer:self.candleShapeLayer];
}

- (void)drawTrackingCross {
    [self releaseTrackingCrossLayer];
    
    if (CGPointEqualToPoint(self.sceneCrossModel.longPressPoint, CGPointZero)) {
        ZLErrorLog(@"不对 CGPointZero 绘制");
        return;
    }
    
    [self.trackingCrosslayer addSublayer:[self getTrackingCrossLayer]];
    
    [self p_addSublayer:self.trackingCrosslayer];
}

#pragma mark - release
- (void)releaseCandleShapeLayer {
    if (self.candleShapeLayer) {
        [self.candleShapeLayer removeFromSuperlayer];
        self.candleShapeLayer = nil;
    }
}

- (void)releaseTrackingCrossLayer {
    if (self.trackingCrosslayer) {
        [self.trackingCrosslayer removeFromSuperlayer];
        self.trackingCrosslayer = nil;
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
- (CAShapeLayer *)getCandleLayerFromModel:(KLineModel *)model Index:(NSInteger)index {
    
    CGFloat sHigherPrice = self.sceneCandleModel.sHigherPrice;
    CGFloat unitValue = self.sceneCandleModel.unitValue;
    CGFloat showCount = self.sceneCandleModel.showCount;
    CGFloat arrayMaxCount = self.sceneCandleModel.arrayMaxCount;
    CGFloat kLineCellSpace = self.sceneCandleModel.kLineCellSpace;
    CGFloat kLineCellWidth = self.sceneCandleModel.kLineCellWidth;
    CGFloat curXScale = self.sceneCandleModel.curXScale;
    
    // 开高低收 位置
    CGFloat openY = (sHigherPrice - model.open) / unitValue;
    CGFloat closeY = (sHigherPrice - model.close) / unitValue;
    // 计算方式 防止屏幕抖动
    CGFloat x = (kLineCellSpace + kLineCellWidth) * index * curXScale; // 从左往右画
    if (showCount == arrayMaxCount) {
        x = self.p_width - (showCount - index) * (kLineCellSpace + kLineCellWidth) * curXScale; //从右往左画 当前条数不足 撑满屏幕时
    }
    
    CGFloat y = MIN(openY, closeY);
    CGFloat height = MAX(fabs(closeY - openY), LINEWIDTH);

    // bezier
    CGRect rect = CGRectMake(x, y, kLineCellWidth * curXScale, height);
    UIBezierPath *cellpath = [UIBezierPath bezierPathWithRect:rect];
    cellpath.lineWidth = LINEWIDTH;
    
    // 最高
    [cellpath moveToPoint:CGPointMake(x + kLineCellWidth * curXScale / 2, y)];
    [cellpath addLineToPoint:CGPointMake(x + kLineCellWidth * curXScale / 2, (sHigherPrice - model.high) / unitValue)];
    
    // 最低
    [cellpath moveToPoint:CGPointMake(x + kLineCellWidth * curXScale / 2, y + height)];
    [cellpath addLineToPoint:CGPointMake(x + kLineCellWidth * curXScale / 2, (sHigherPrice - model.low) / unitValue)];
    
    CAShapeLayer *cellCAShapeLayer = [CAShapeLayer layer];
    cellCAShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    cellCAShapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //调整颜色
    if (model.open == model.close) {
        cellCAShapeLayer.strokeColor = _nColor.CGColor;
    }else if (model.open > model.close){
        cellCAShapeLayer.strokeColor = _uColor.CGColor;
    }else{
        cellCAShapeLayer.strokeColor = _dColor.CGColor;
        cellCAShapeLayer.fillColor = _dColor.CGColor;
    }
    cellCAShapeLayer.path = cellpath.CGPath;
    
    [cellpath removeAllPoints];
    return cellCAShapeLayer;
}

- (CAShapeLayer *)getTrackingCrossLayer {
    CGFloat sHigherPrice = self.sceneCrossModel.sHigherPrice;
    CGFloat unitValue = self.sceneCrossModel.unitValue;
    CGFloat kLineCellSpace = self.sceneCrossModel.kLineCellSpace;
    CGFloat kLineCellWidth = self.sceneCrossModel.kLineCellWidth;
    CGFloat curXScale = self.sceneCrossModel.curXScale;
    CGFloat x = self.sceneCrossModel.longPressPoint.x;
//    CGFloat y = self.sceneCrossModel.longPressPoint.y;
    
    CGFloat curCellStep = (kLineCellSpace + kLineCellWidth) * curXScale;
    NSInteger index = x / curCellStep;
    CGFloat crossX = index * curCellStep + kLineCellWidth * curXScale / 2;
    
    KLineModel *model = [self.curShowArray objectAtIndex:index];
    CGFloat adge = 3 * curXScale;
    
    CGFloat top = (sHigherPrice - model.high) / unitValue - adge;
    CGFloat bottom = (sHigherPrice - model.low) / unitValue + adge;
    CGFloat left = (kLineCellSpace + kLineCellWidth) * index * curXScale - adge;
    CGFloat right = (kLineCellSpace + kLineCellWidth) * index * curXScale + kLineCellWidth * curXScale + adge;
    CGFloat openY = (sHigherPrice - model.open) / unitValue;
    
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    crossPath.lineCapStyle = kCGLineCapRound; //线条拐角
    crossPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    // xCross
    [crossPath moveToPoint:CGPointMake(0, openY)];
    [crossPath addLineToPoint:CGPointMake(left, openY)];
    [crossPath moveToPoint:CGPointMake(right, openY)];
    [crossPath addLineToPoint:CGPointMake(self.p_width, openY)];
    
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
