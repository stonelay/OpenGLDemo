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

#define LongitudeTitleFontSize  12
#define LatitudeTitleFontSize   10

#define LongitudeStrokeColor    ZLGray(167)
#define LongitudeTitleColor     ZLGray(99)
#define LatitudeStrokeColor     ZLGray(167)
#define LatitudeTitleColor      ZLGray(99)

@interface ZLGridePainter()

@property (nonatomic, strong) CAShapeLayer *borderShapeLayer;
@property (nonatomic, strong) CAShapeLayer *xAxisShapeLayer;

@property (nonatomic, strong) CAShapeLayer *latitudeLayer;
@property (nonatomic, strong) CAShapeLayer *longitudeLayer;

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

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {
    [self drawLongittueLines];
    [self drawLatitudeLines];
}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {
    [self drawLongittueLines];
    [self drawLatitudeLines];
}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {}
- (void)longPressChangedLocation:(CGPoint)location {}
- (void)longPressEndedLocation:(CGPoint)location {}

#pragma mark - draw
- (void)drawBorder {
    CGRect border = self.s_bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:border];
    self.borderShapeLayer.path = path.CGPath;
    [self p_addSublayer:self.borderShapeLayer];
}

- (void)drawAxis {
    // TODO 坐标线没想好，以后修改
    CGPoint pointXBegin = CGPointMake(0, self.p_height);
    CGPoint pointXEnd = CGPointMake(self.p_width, self.p_height);
    CGPoint pointYBegin = CGPointMake(self.screenEdgeInsets.left, 0);
    CGPoint pointYEnd = CGPointMake(self.screenEdgeInsets.left, self.p_height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointXBegin];
    [path addLineToPoint:pointXEnd];
    [path moveToPoint:pointYBegin];
    [path addLineToPoint:pointYEnd];
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    self.xAxisShapeLayer.path = path.CGPath;
    
    [path removeAllPoints];
    [self p_addSublayer:self.xAxisShapeLayer];
}

- (void)drawLatitudeLines {
    [self releaseLatitudeLayer];
    
    // 经线绘制方式 绘制大于等于 五条
    NSUInteger showCount = [self.dataSource showNumberInPainter:self];
    NSUInteger step = showCount / 4;
    
    NSArray *curShowArray = [self.dataSource showArrayInPainter:self];
    
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    for (int i = 0; i < showCount; i+=step) {
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        leftX += candleWidth(cellWidth) / 2 + candleLeftAdge(cellWidth);
        
        CAShapeLayer *subLatitudeLayer = [self getLatitudeLayerFromPositionX:leftX];
        [self.latitudeLayer addSublayer:subLatitudeLayer];
        
        KLineModel *model = curShowArray[i];
        CATextLayer *titleLayer = [self getLatitudeTitleFromPositionX:leftX title:model.date];
        [self.latitudeLayer addSublayer:titleLayer];
    }
    
    [self p_addSublayer:self.latitudeLayer];
}

- (void)drawLongittueLines {
    [self releaseLongitudeLayer];
    
    // 纬线 绘制方式 最高最低， 等分3 四条
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat sLowerPrice = [self.delegate sLowerInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    
    CGFloat curHigherPrice = sHigherPrice / kHScale;
    CGFloat curLowerPrice = sLowerPrice / kLScale;
    
    CGFloat higherY = (sHigherPrice - curHigherPrice) / unitValue;
    CGFloat lowerY = (sHigherPrice - curLowerPrice) / unitValue;
    
    [self addLongitudeWithPrice:curHigherPrice positionY:higherY];
    [self addLongitudeWithPrice:(curHigherPrice + curLowerPrice) / 3 * 1 positionY:(higherY + lowerY) / 3 * 1];
    [self addLongitudeWithPrice:(curHigherPrice + curLowerPrice) / 3 * 2 positionY:(higherY + lowerY) / 3 * 2];
    [self addLongitudeWithPrice:curLowerPrice positionY:lowerY];

    [self p_addSublayer:self.longitudeLayer];
}

- (void)releaseBorderShapeLayer{
    if (_borderShapeLayer) {
        [_borderShapeLayer removeFromSuperlayer];
        _borderShapeLayer = nil;
    }
}

- (void)releaseXAxisShapeLayer {
    if (_xAxisShapeLayer) {
        [_xAxisShapeLayer removeFromSuperlayer];
        _xAxisShapeLayer = nil;
    }
}

- (void)releaseLongitudeLayer {
    if (_longitudeLayer) {
        [_longitudeLayer removeFromSuperlayer];
        _longitudeLayer = nil;
    }
}

- (void)releaseLatitudeLayer {
    if (_latitudeLayer) {
        [_latitudeLayer removeFromSuperlayer];
        _latitudeLayer = nil;
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

#pragma mark - sublayers
- (CAShapeLayer *)getLatitudeLayerFromPositionX:(CGFloat)positionX {
    
    UIBezierPath *latpath = [UIBezierPath bezierPath];
    latpath.lineWidth = LINEWIDTH;
    
    [latpath moveToPoint:CGPointMake(positionX, 0)];
    [latpath addLineToPoint:CGPointMake(positionX, self.p_height)];
    
    CAShapeLayer *latLayer = [CAShapeLayer layer];
    latLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    latLayer.strokeColor = LatitudeStrokeColor.CGColor;
    latLayer.lineDashPattern = @[@3, @5];
    
    latLayer.path = latpath.CGPath;
    [latpath removeAllPoints];
    
    return latLayer;
}

- (CATextLayer *)getLatitudeTitleFromPositionX:(CGFloat)positionX title:(NSString *)title {
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = LatitudeTitleFontSize;
    layer.alignmentMode = kCAAlignmentJustified;
    layer.foregroundColor = LatitudeTitleColor.CGColor;
    
    if (!title) return layer;
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(LatitudeTitleFontSize)}];
    layer.string = title;
    
    positionX -= titleSize.width / 2;
    
    if (positionX < 0) {
        positionX += titleSize.width / 2;
    } else if (positionX + titleSize.width > self.p_width) {
        positionX -= titleSize.width / 2;
    }
    
    layer.frame = CGRectMake(positionX, self.p_height + 4, titleSize.width, titleSize.height);
    return layer;
}

- (CAShapeLayer *)getLongitudeLayerFromPositionY:(CGFloat)positionY {
    UIBezierPath *lonpath = [UIBezierPath bezierPath];
    lonpath.lineWidth = LINEWIDTH;
    
    [lonpath moveToPoint:CGPointMake(0, positionY)];
    [lonpath addLineToPoint:CGPointMake(self.p_width, positionY)];
    
    CAShapeLayer *lonLayer = [CAShapeLayer layer];
    lonLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    lonLayer.strokeColor = LongitudeStrokeColor.CGColor;
    lonLayer.lineDashPattern = @[@2, @2];
    
    lonLayer.path = lonpath.CGPath;
    [lonpath removeAllPoints];

    return lonLayer;
}

- (CATextLayer *)getLongitudeTitleFromPositionY:(CGFloat)positionY title:(NSString *)title {
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = LongitudeTitleFontSize;
    layer.alignmentMode = kCAAlignmentJustified;
    layer.foregroundColor = LongitudeTitleColor.CGColor;
    
    if (!title) return layer;
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(LongitudeTitleFontSize)}];
    layer.string = title;
    
    layer.frame = CGRectMake(4, positionY - titleSize.height - 2, titleSize.width, titleSize.height);
    return layer;
}

- (void)addLongitudeWithPrice:(CGFloat)price positionY:(CGFloat)positionY {
    CAShapeLayer *lonLayer = [self getLongitudeLayerFromPositionY:positionY];
    CATextLayer *lonTitleLayer = [self getLongitudeTitleFromPositionY:positionY title:[NSString stringWithFormat:@"%.2f", price]];
    [self.longitudeLayer addSublayer:lonLayer];
    [self.longitudeLayer addSublayer:lonTitleLayer];
}

- (void)p_clear {
    [self releaseBorderShapeLayer];
    [self releaseXAxisShapeLayer];
    [self releaseLatitudeLayer];
    [self releaseLongitudeLayer];
}


@end
