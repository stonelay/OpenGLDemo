//
//  ZLMAPainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/27.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLMAPainter.h"

#import "ZLGuideModel.h"
#import "ZLMAParam.h"

@interface ZLMAPainter()

@property (nonatomic, strong) CAShapeLayer *maLayer;

@end

@implementation ZLMAPainter

- (void)p_initDefault {
    [super p_initDefault];
//    self.maLayer.strokeColor = maColor.CGColor;
}

#pragma mark - override
- (void)draw {
    [super draw];
    [self drawMa];
}

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {
    [self drawMa];
}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {
    [self drawMa];
}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {}
- (void)longPressChangedLocation:(CGPoint)location {}
- (void)longPressEndedLocation:(CGPoint)location {}

#pragma mark - draw
- (void)drawMa {
    [self releaseMaLayer];
    
    [self.maLayer addSublayer:[self getGuideByMA:PKey_MADataID_MA1]];
    [self.maLayer addSublayer:[self getGuideByMA:PKey_MADataID_MA2]];
    [self.maLayer addSublayer:[self getGuideByMA:PKey_MADataID_MA3]];
    [self.maLayer addSublayer:[self getGuideByMA:PKey_MADataID_MA4]];
    [self.maLayer addSublayer:[self getGuideByMA:PKey_MADataID_MA5]];
    
    [self p_addSublayer:self.maLayer];
}

#pragma mark - release
- (void)releaseMaLayer{
    if (_maLayer) {
        [_maLayer removeFromSuperlayer];
        _maLayer = nil;
    }
}

#pragma mark - property
- (CAShapeLayer *)maLayer {
    if (!_maLayer) {
        _maLayer = [CAShapeLayer layer];
        _maLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _maLayer.fillColor = ZLClearColor.CGColor;
        _maLayer.lineWidth = LINEWIDTH;
    }
    return _maLayer;
}

- (CAShapeLayer *)getGuideByMA:(NSString *)ma {
    ZLGuideDataPack *dataPack = [self.dataSource painter:self dataPackByMA:ma];
    if (!dataPack) {
        return nil;
    }
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = [self.dataSource showNumberInPainter:self];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    NSArray *guideArray = dataPack.dataArray;
    ZLMAParam *maParams = (ZLMAParam *)dataPack.param;
    
    UIBezierPath *maPath = [UIBezierPath bezierPath];
    maPath.lineWidth = LINEWIDTH;
    
    CAShapeLayer *maShapeLayer = [CAShapeLayer layer];
    maShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    maShapeLayer.strokeColor = maParams.maColor.CGColor;
    maShapeLayer.fillColor = ZLClearColor.CGColor;
    
    BOOL hasHead = NO;
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideModel *model = guideArray[i];
        if (!model.needDraw) continue;
        
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        leftX += candleLeftAdge(cellWidth);
        
        CGFloat maY = (sHigherPrice - model.data) / unitValue;
        if (hasHead) {
            [maPath addLineToPoint:CGPointMake(leftX + candleWidth(cellWidth) / 2, maY)];
        } else {
            [maPath moveToPoint:CGPointMake(leftX + candleWidth(cellWidth) / 2, maY)];
            hasHead = YES;
        }
    }
    
    maShapeLayer.path = maPath.CGPath;
    [maPath removeAllPoints];
    
    return maShapeLayer;
}

- (void)p_clear {
    [self releaseMaLayer];
}


@end
