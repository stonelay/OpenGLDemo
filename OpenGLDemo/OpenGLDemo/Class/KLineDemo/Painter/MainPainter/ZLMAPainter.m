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

#define MATitleFontSize 12

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

// tap
- (void)tapAtPoint:(CGPoint)point {}

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
    
    NSMutableArray *dataPacks = [[NSMutableArray alloc] init];
    // safe nill
    [dataPacks addObject:[self.dataSource painter:self dataPackByMA:PKey_MADataID_MA1]];
    [dataPacks addObject:[self.dataSource painter:self dataPackByMA:PKey_MADataID_MA2]];
    [dataPacks addObject:[self.dataSource painter:self dataPackByMA:PKey_MADataID_MA3]];
    [dataPacks addObject:[self.dataSource painter:self dataPackByMA:PKey_MADataID_MA4]];
    [dataPacks addObject:[self.dataSource painter:self dataPackByMA:PKey_MADataID_MA5]];
    
    CGFloat sHigherPrice = [self.delegate sHigherInPainter:self];
    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat showCount = [self.dataSource showNumberInPainter:self];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    BOOL isShowAll = [self.dataSource isShowAllInPainter:self];
    
    for (int i = 0; i < dataPacks.count; i++) {
        ZLGuideDataPack *dataPack = dataPacks[i];
        [self.maLayer addSublayer:[self getMALayerByDataPack:dataPack higherPrice:sHigherPrice unitValue:unitValue showCount:showCount cellWidth:cellWidth isShowAll:isShowAll]];
        [self.maLayer addSublayer:[self getMaInforByMAParam:(ZLMAParam *)dataPack.param atIndex:i]];
    }
    
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
        _maLayer.frame = self.p_frame;
        _maLayer.fillColor = ZLClearColor.CGColor;
        _maLayer.lineWidth = LINEWIDTH;
    }
    return _maLayer;
}

- (CAShapeLayer *)getMALayerByDataPack:(ZLGuideDataPack *)dataPack
                           higherPrice:(CGFloat)sHigherPrice
                             unitValue:(CGFloat)unitValue
                             showCount:(NSUInteger)showCount
                             cellWidth:(CGFloat)cellWidth
                             isShowAll:(BOOL)isShowAll {
    
    NSArray *guideArray = dataPack.dataArray;
    ZLMAParam *maParams = (ZLMAParam *)dataPack.param;
    
    UIBezierPath *maPath = [UIBezierPath bezierPath];
    maPath.lineWidth = LINEWIDTH;
    
    CAShapeLayer *maShapeLayer = [CAShapeLayer layer];
    maShapeLayer.frame = self.p_bounds;
    maShapeLayer.strokeColor = maParams.maColor.CGColor;
    maShapeLayer.fillColor = ZLClearColor.CGColor;
    
    BOOL hasHead = NO;
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideModel *model = guideArray[i];
        if (!model.needDraw) continue;
        
        CGFloat leftX = cellWidth * i; // 从左往右画 // 计算方式 防止屏幕抖动
        if (isShowAll) {
            leftX = self.p_width - (showCount - i) * cellWidth; //从右往左画 当前条数不足 撑满屏幕时
        }
        leftX += candleLeftAdge(cellWidth);
        leftX += candleWidth(cellWidth) / 2;
        
        CGFloat maY = (sHigherPrice - model.data) / unitValue;
        if (hasHead) {
            [maPath addLineToPoint:CGPointMake(leftX, maY)];
        } else {
            [maPath moveToPoint:CGPointMake(leftX, maY)];
            hasHead = YES;
        }
    }
    
    maShapeLayer.path = maPath.CGPath;
    [maPath removeAllPoints];
    
    return maShapeLayer;
}

- (CATextLayer *)getMaInforByMAParam:(ZLMAParam *)param atIndex:(NSInteger)index {
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = MATitleFontSize;
    layer.alignmentMode = kCAAlignmentJustified;
    layer.foregroundColor = param.maColor.CGColor;
    
    NSString *title = [NSString stringWithFormat:@"MA %d", (int)param.period];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(MATitleFontSize)}];
    layer.string = title;
    
    layer.frame = CGRectMake(4, (titleSize.height + 2) * index, titleSize.width, titleSize.height);
    return layer;
}

- (void)p_clear {
    [self releaseMaLayer];
}


@end
