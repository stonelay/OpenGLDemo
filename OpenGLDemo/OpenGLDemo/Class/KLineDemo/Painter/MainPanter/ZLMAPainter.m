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
    
    ZLGuideDataPack *dataPack = [self.dataSource painter:self dataPackByMA:PKey_MADataID_MA1];
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = [self.dataSource showNumberInPainter:self];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    NSArray *guideArray = dataPack.dataArray;
    ZLMAParam *maParams = (ZLMAParam *)dataPack.param;
    
    UIBezierPath *cellpath = [UIBezierPath bezierPath];
    cellpath.lineWidth = LINEWIDTH;
    
    CAShapeLayer *cellCAShapeLayer = [CAShapeLayer layer];
    cellCAShapeLayer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
    cellCAShapeLayer.strokeColor = maParams.maColor.CGColor;
    
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideModel *model = guideArray[i];
        
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        
        CGFloat maY = (sHigherPrice - model.data) / unitValue;
        if (i == 0) {
            [cellpath moveToPoint:CGPointMake(leftX, maY)];
        } else {
            [cellpath addLineToPoint:CGPointMake(leftX, maY)];
        }
    }
    
    cellCAShapeLayer.path = cellpath.CGPath;
    [cellpath removeAllPoints];
    
    [self.maLayer addSublayer:cellCAShapeLayer];
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

- (void)p_clear {
    [self releaseMaLayer];
}


@end
