//
//  ZLBOLLPainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/31.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLBOLLPainter.h"

#import "ZLGuideModel.h"
#import "ZLBOLLParam.h"

#import "GuideDataType.h"

@interface ZLBOLLPainter()

@property (nonatomic, strong) CAShapeLayer *bollLayer;

@end

@implementation ZLBOLLPainter

- (void)p_initDefault {
    [super p_initDefault];
}

#pragma mark - override
- (void)draw {
    [super draw];
    [self drawBoll];
}

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {
    [self drawBoll];
}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {
    [self drawBoll];
}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {}
- (void)longPressChangedLocation:(CGPoint)location {}
- (void)longPressEndedLocation:(CGPoint)location {}

#pragma mark - draw
- (void)drawBoll {
    [self releaseBollLayer];
    
    ZLGuideDataPack *dataPack = [self.dataSource bollDataPackInPainter:self];
    if (!dataPack) {
        return;
    }
    [self.bollLayer addSublayer:[self getBollByDataPack:dataPack]];
    [self.bollLayer addSublayer:[self getBollBandByDataPack:dataPack]];
    
    [self p_addSublayer:self.bollLayer];
}

#pragma mark - release
- (void)releaseBollLayer{
    if (_bollLayer) {
        [_bollLayer removeFromSuperlayer];
        _bollLayer = nil;
    }
}

#pragma mark - property
- (CAShapeLayer *)bollLayer {
    if (!_bollLayer) {
        _bollLayer = [CAShapeLayer layer];
        _bollLayer.frame = self.p_frame;
        _bollLayer.fillColor = ZLClearColor.CGColor;
        _bollLayer.lineWidth = LINEWIDTH;
    }
    return _bollLayer;
}

- (CAShapeLayer *)getBollByDataPack:(ZLGuideDataPack *)dataPack {
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = [self.dataSource showNumberInPainter:self];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    NSArray *guideArray = dataPack.dataArray;
    ZLBOLLParam *bollParams = (ZLBOLLParam *)dataPack.param;
    
    UIBezierPath *upPath = [UIBezierPath bezierPath];
    upPath.lineWidth = LINEWIDTH;
    UIBezierPath *midPath = [UIBezierPath bezierPath];
    midPath.lineWidth = LINEWIDTH;
    UIBezierPath *lowPath = [UIBezierPath bezierPath];
    lowPath.lineWidth = LINEWIDTH;
    
    CAShapeLayer *upLayer = [CAShapeLayer layer];
    upLayer.frame = self.p_bounds;
    upLayer.fillColor = ZLClearColor.CGColor;
    upLayer.strokeColor = [bollParams colorWithDataName:ZLBOLLDataName_UP].CGColor;
   
    CAShapeLayer *midLayer = [CAShapeLayer layer];
    midLayer.frame = self.p_bounds;
    midLayer.fillColor = ZLClearColor.CGColor;
    midLayer.strokeColor = [bollParams colorWithDataName:ZLBOLLDataName_MID].CGColor;
    
    CAShapeLayer *lowLayer = [CAShapeLayer layer];
    lowLayer.frame = self.p_bounds;
    lowLayer.fillColor = ZLClearColor.CGColor;
    lowLayer.strokeColor = [bollParams colorWithDataName:ZLBOLLDataName_LOW].CGColor;
    
    BOOL isHead = YES;
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideModel *model = guideArray[i];
        if (!model.needDraw) continue;
        
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        leftX += candleLeftAdge(cellWidth);
        leftX += candleWidth(cellWidth) / 2;
        
        CGFloat upY = (sHigherPrice - [model getDataWithDataName:ZLBOLLDataName_UP]) / unitValue;
        CGFloat midY = (sHigherPrice - [model getDataWithDataName:ZLBOLLDataName_MID]) / unitValue;
        CGFloat lowY = (sHigherPrice - [model getDataWithDataName:ZLBOLLDataName_LOW]) / unitValue;
        if (isHead) {
            [upPath moveToPoint:CGPointMake(leftX, upY)];
            [midPath moveToPoint:CGPointMake(leftX, midY)];
            [lowPath moveToPoint:CGPointMake(leftX, lowY)];
            isHead = NO;
        } else {
            [upPath addLineToPoint:CGPointMake(leftX, upY)];
            [midPath addLineToPoint:CGPointMake(leftX, midY)];
            [lowPath addLineToPoint:CGPointMake(leftX, lowY)];
        }
    }
    
    CAShapeLayer *bollLayer = [CAShapeLayer layer];
    bollLayer.frame = self.p_bounds;
    
    upLayer.path = upPath.CGPath;
    [upPath removeAllPoints];
    [bollLayer addSublayer:upLayer];
    
    midLayer.strokeColor = [bollParams colorWithDataName:ZLBOLLDataName_MID].CGColor;
    midLayer.path = midPath.CGPath;
    [midPath removeAllPoints];
    [bollLayer addSublayer:midLayer];
    
    lowLayer.strokeColor = [bollParams colorWithDataName:ZLBOLLDataName_LOW].CGColor;
    lowLayer.path = lowPath.CGPath;
    [lowPath removeAllPoints];
    [bollLayer addSublayer:lowLayer];
    
    return bollLayer;
}

- (CAShapeLayer *)getBollBandByDataPack:(ZLGuideDataPack *)dataPack {
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = [self.dataSource showNumberInPainter:self];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowArray = [self.dataSource isShowAllInPainter:self];
    
    NSArray *guideArray = dataPack.dataArray;
    ZLBOLLParam *bollParams = (ZLBOLLParam *)dataPack.param;
    
    UIBezierPath *bandPath = [UIBezierPath bezierPath];
    bandPath.lineWidth = LINEWIDTH;
    
    CAShapeLayer *bandShapeLayer = [CAShapeLayer layer];
    bandShapeLayer.frame = self.p_bounds;
    bandShapeLayer.strokeColor = ZLClearColor.CGColor;
    bandShapeLayer.fillColor = bollParams.bandColor.CGColor;
    
    NSMutableArray *tUpArray = [[NSMutableArray alloc] init];
    NSMutableArray *tLowArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideModel *model = guideArray[i];
        if (!model.needDraw) continue;
        
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowArray) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        leftX += candleLeftAdge(cellWidth);
        leftX += candleWidth(cellWidth) / 2;
        
        CGFloat upY = (sHigherPrice - [model getDataWithDataName:ZLBOLLDataName_UP]) / unitValue;
        CGFloat lowY = (sHigherPrice - [model getDataWithDataName:ZLBOLLDataName_LOW]) / unitValue;
        
        [tUpArray addObject:[NSValue valueWithCGPoint:CGPointMake(leftX, upY)]];
        [tLowArray addObject:[NSValue valueWithCGPoint:CGPointMake(leftX, lowY)]];
    }
    
    for (int i = 0; i < tUpArray.count; i++) {
        if (i == 0) {
            [bandPath moveToPoint:[tUpArray[i] CGPointValue]];
        } else {
            [bandPath addLineToPoint:[tUpArray[i] CGPointValue]];
        }
    }
    
    for (int i = (int)tLowArray.count - 1; i >=0; i--) {
        [bandPath addLineToPoint:[tLowArray[i] CGPointValue]];
    }
    
    bandShapeLayer.path = bandPath.CGPath;
    [bandPath removeAllPoints];
    
    return bandShapeLayer;
}

- (void)p_clear {
    [self releaseBollLayer];
}

@end
