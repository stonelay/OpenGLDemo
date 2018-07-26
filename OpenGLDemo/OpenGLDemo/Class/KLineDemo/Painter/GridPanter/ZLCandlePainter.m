//
//  ZLCandlePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLCandlePainter.h"
#import "KLineModel.h"

#define UninitializedIndex   -1

#define UpColor         ZLHEXCOLOR(0xDC143C)
#define DownColor       ZLHEXCOLOR(0x47D3D1)
#define NormalColor     ZLHEXCOLOR(0xFAFAD2)

@interface ZLCandlePainter() {
    CGFloat _kLineCellSpace;    //cell间隔
    CGFloat _kLineCellWidth;    //cell宽度
    
    CGFloat _kMinScale;     //最小缩放量
    CGFloat _kMaxScale;     //最大缩放量
    
    UIColor *_uColor; // 涨
    UIColor *_dColor; // 跌
    UIColor *_nColor; // 平
}

@property (nonatomic, assign) NSUInteger arrayMaxCount; // 最大展示个数

@property (nonatomic, strong) CAShapeLayer *candleShapeLayer;  // 蜡烛线
@property (nonatomic, strong) CAShapeLayer *trackingCrosslayer;// 十字线

@property (nonatomic, strong) NSArray *needShowArray;

// value
@property (nonatomic, assign) CGFloat unitValue;    // 单位点的值
@property (nonatomic, assign) NSUInteger showCount; // 当前页面显示的个数


@property (nonatomic, assign) NSInteger oriIndex;   // pan 之前的第一条index
@property (nonatomic, assign) NSInteger curIndex;   // pan 中当前index

@property (nonatomic, assign) CGFloat oriXScale;      // pinch 之前缩放比例
@property (nonatomic, assign) CGFloat curXScale;      // pinch 中当前缩放比例

@property (nonatomic, assign) CGFloat sHigherPrice;   // 当前屏幕最高价
@property (nonatomic, assign) CGFloat sLowerPrice;   // 当前屏幕最高价

@property (nonatomic, assign) CGPoint moveBeginPoint;
@property (nonatomic, assign) CGPoint moveEndPoint;


@end

@implementation ZLCandlePainter

- (void)p_initDefault {
    _kLineCellSpace = 4 * SCALE;    //cell间隔
    _kLineCellWidth = 8 * SCALE;    //cell宽度
    
    _kMinScale = 0.1;     //最小缩放量
    _kMaxScale = 4.0;     //最大缩放量
    
    self.oriXScale = 1.0;
    self.oriIndex = UninitializedIndex;
    
    _uColor = UpColor;
    _dColor = DownColor;
    _nColor = NormalColor;
}

#pragma mark - override
- (void)draw {
    if (!self.p_havePaintView) {
        return;
    }
    [self prepareDrawWithPoint:CGPointZero andScale:1.0];
    [self drawCandle];
}

// pan
- (void)panBeginPoint:(CGPoint)point {
    self.oriIndex = self.curIndex;
}

- (void)panChangePoint:(CGPoint)point {
    [self prepareDrawWithPoint:point andScale:1.0];
    [self drawCandle];
}

- (void)panEndPoint:(CGPoint)point {
    self.oriIndex = self.curIndex;
}

// pinch
- (void)pinchBeginScale:(CGFloat)scale {
    self.oriXScale = self.curXScale;
}

- (void)pinchChangeScale:(CGFloat)scale {
    [self prepareDrawWithPoint:CGPointZero andScale:scale];
    [self drawCandle];
}

- (void)pinchEndScale:(CGFloat)scale {
    self.oriXScale = self.curXScale;
}

#pragma mark - draw
- (void)drawCandle {
    [self releaseCandleShapeLayer];
    [self.needShowArray enumerateObjectsUsingBlock:^(KLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *cellCAShapeLayer = [self getSublayerFromModel:model Index:idx];
        [self.candleShapeLayer addSublayer:cellCAShapeLayer];
    }];

    [self p_addSublayer:self.candleShapeLayer];
}

- (void)prepareDrawWithPoint:(CGPoint)point andScale:(CGFloat)scale {
    [self fixScale:scale];
    [self fixShowCount];
    [self fixBeginIndexWithPoint:point];
    [self fixShowData];
    [self fixMaximum];
}

// 计算 缩放比例
- (void)fixScale:(CGFloat)scale {
    CGFloat curScale = self.oriXScale * scale;
    curScale = MAX(curScale, _kMinScale);
    curScale = MIN(curScale, _kMaxScale);
    
    self.curXScale = curScale;
}

// 计算 要显示几个
- (void)fixShowCount {
    if ([self.dataSource respondsToSelector:@selector(maxNumberOfPainter:)]) {
        self.arrayMaxCount = [self.dataSource maxNumberOfPainter:self];
    }
    self.showCount = self.p_width / ((_kLineCellSpace + _kLineCellWidth) * self.curXScale);
    if (self.showCount > self.arrayMaxCount) {
        self.showCount = self.arrayMaxCount;
    }
}

// 计算 从第几个开始显示
- (void)fixBeginIndexWithPoint:(CGPoint)point {
    if (self.oriIndex == UninitializedIndex) {
        NSInteger beginIndex = self.arrayMaxCount - self.showCount;
        if (beginIndex < 0) {
            beginIndex = 0;
        }
        self.oriIndex = beginIndex;//初始化偏移位置
    }
    
    CGFloat cellWidth = ((_kLineCellSpace + _kLineCellWidth) * self.curXScale);
    
    self.curIndex = self.oriIndex - point.x / cellWidth;
}

- (void)fixShowData {
    if (self.curIndex < 0) {
        self.curIndex = 0;
    }
    
    if (self.curIndex > self.arrayMaxCount - self.showCount) {
        self.curIndex = self.arrayMaxCount - self.showCount;
    }
    
    NSUInteger fIndex = self.curIndex;
    NSUInteger length = self.showCount;

    if ([self.dataSource respondsToSelector:@selector(paintArrayFrom:length:painter:)]) {
        self.needShowArray = [[self.dataSource paintArrayFrom:fIndex length:length painter:self] copy];
    }
}

// 计算最高最低 和 单位值
- (void)fixMaximum {
    self.sLowerPrice = FLT_MAX;
    self.sHigherPrice = 0;
    
    for (KLineModel *model in self.needShowArray) {
        self.sHigherPrice = MAX(model.high, self.sHigherPrice);
        self.sLowerPrice = MIN(model.low, self.sLowerPrice);
    }
    
    // 预留屏幕上下空隙
    self.sLowerPrice *= 0.95;
    self.sHigherPrice *= 1.05;
    
    // 计算每个点代表的值是多少
    self.unitValue = (self.sHigherPrice - self.sLowerPrice) / self.p_height;
}

#pragma mark - release
- (void)releaseCandleShapeLayer {
    if (self.candleShapeLayer) {
        [self.candleShapeLayer removeFromSuperlayer];
        self.candleShapeLayer = nil;
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

#pragma mark - sublayers
- (CAShapeLayer *)getSublayerFromModel:(KLineModel *)model Index:(NSInteger)index {
    // 开盘
    CGFloat openY = (self.sHigherPrice - model.open) / self.unitValue;
    CGFloat closeY = (self.sHigherPrice - model.close) / self.unitValue;
    CGFloat x = (_kLineCellSpace + _kLineCellWidth) * index * self.curXScale;
    CGFloat y = MIN(openY, closeY);
    CGFloat height = MAX(fabs(closeY - openY), LINEWIDTH);

    // bezier
    CGRect rect = CGRectMake(x, y, _kLineCellWidth * self.curXScale, height);
    UIBezierPath *cellpath = [UIBezierPath bezierPathWithRect:rect];
    cellpath.lineWidth = LINEWIDTH;
    
    // 最高
    [cellpath moveToPoint:CGPointMake(x + _kLineCellWidth * self.curXScale / 2, y)];
    [cellpath addLineToPoint:CGPointMake(x + _kLineCellWidth * self.curXScale / 2, (self.sHigherPrice - model.high) / self.unitValue)];
    
    // 最低
    [cellpath moveToPoint:CGPointMake(x + _kLineCellWidth * self.curXScale / 2, y + height)];
    [cellpath addLineToPoint:CGPointMake(x + _kLineCellWidth * self.curXScale / 2, (self.sHigherPrice - model.low) / self.unitValue)];
    
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

- (void)p_clear {
    [self releaseCandleShapeLayer];
}

@end
