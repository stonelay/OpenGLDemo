//
//  ZLKDJPainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/8/2.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLKDJPainter.h"

#import "ZLKDJParam.h"
#import "ZLGuideKDJModel.h"

@interface ZLKDJPainter()

@property (nonatomic, strong) CAShapeLayer *kdjLayer;
@property (nonatomic, strong) CAShapeLayer *kdjInforLayer;

@end

@implementation ZLKDJPainter

- (void)p_initDefault {
    [super p_initDefault];
}

#pragma mark - override
- (void)draw {
    [super draw];
    [self drawKDJ];
    [self drawKDJInfor];
}

// tap
- (void)tapAtPoint:(CGPoint)point {}

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {
    [self drawKDJ];
    [self drawKDJInfor];
}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {
    [self drawKDJ];
    [self drawKDJInfor];
}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    [self drawKDJInfor];
}
- (void)longPressChangedLocation:(CGPoint)location {
    [self drawKDJInfor];
}
- (void)longPressEndedLocation:(CGPoint)location {
    [self drawKDJInfor];
}

#pragma mark - draw
- (void)drawKDJ {
    [self releaseKDJLayer];
    
    ZLGuideDataPack *dataPack = [self.dataSource kdjDataPackInPainter:self];
    if (!dataPack) {
        return;
    }
    
    [self.kdjLayer addSublayer:[self getKDJByDataPack:dataPack]];
//    [self.kdjLayer addSublayer:[self getKDJByDataPack:dataPack]];
//    [self.kdjLayer addSublayer:[self getKDJBandByDataPack:dataPack]];
    
    [self p_addSublayer:self.kdjLayer];
}

- (void)drawKDJInfor {
    [self releaseKDJInforLayer];
    
//    ZLGuideDataPack *dataPack = [self.dataSource kdjDataPackInPainter:self];
//    if (!dataPack) {
//        return;
//    }
//
//    NSInteger crossIndex = [self.dataSource longPressIndexInPainter:self];
//    ZLGuideKDJModel *guideModel = [dataPack.dataArray objectAtIndex:crossIndex];
//
//    ZLKDJParam *bollParam = (ZLKDJParam *)dataPack.param;
//    NSString *bollTitle = [NSString stringWithFormat:@"KDJ(%d, %d)",(int) bollParam.period, (int)bollParam.k];
//    NSString *mTitle = [NSString stringWithFormat:@"M:%.2f", guideModel.midData];
//    NSString *tTitle = [NSString stringWithFormat:@"T:%.2f", guideModel.upData];
//    NSString *bTitle = [NSString stringWithFormat:@"B:%.2f", guideModel.lowData];
//
//    CGSize bollSize = [bollTitle sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(BollTitleFontSize)}];
//    self.bollSublayer.string = bollTitle;
//    self.bollSublayer.foregroundColor = bollParam.midColor.CGColor;
//    self.bollSublayer.frame = CGRectMake(2, 1 - self.p_top, bollSize.width, bollSize.height);
//
//    CGSize mSize = [mTitle sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(BollTitleFontSize)}];
//    self.mSublayer.string = mTitle;
//    self.mSublayer.foregroundColor = bollParam.midColor.CGColor;
//    self.mSublayer.frame = CGRectMake(self.bollSublayer.right + 10, 1 - self.p_top, mSize.width, mSize.height);
//
//    CGSize tSize = [tTitle sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(BollTitleFontSize)}];
//    self.tSublayer.string = tTitle;
//    self.tSublayer.foregroundColor = bollParam.upColor.CGColor;
//    self.tSublayer.frame = CGRectMake(self.mSublayer.right + 10, 1 - self.p_top, tSize.width, tSize.height);
//
//    CGSize bSize = [bTitle sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(BollTitleFontSize)}];
//    self.bSublayer.string = bTitle;
//    self.bSublayer.foregroundColor = bollParam.lowColor.CGColor;
//    self.bSublayer.frame = CGRectMake(self.tSublayer.right + 10, 1 - self.p_top, bSize.width, bSize.height);
//
//    [self.bollLayer addSublayer:self.bollSublayer];
//    [self.bollLayer addSublayer:self.tSublayer];
//    [self.bollLayer addSublayer:self.mSublayer];
//    [self.bollLayer addSublayer:self.bSublayer];
    
    [self p_addSublayer:self.kdjInforLayer];
}

#pragma mark - release
- (void)releaseKDJLayer {
    if (_kdjLayer) {
        [_kdjLayer removeFromSuperlayer];
        _kdjLayer = nil;
    }
}

- (void)releaseKDJInforLayer {
    if (_kdjInforLayer) {
        [_kdjInforLayer removeFromSuperlayer];
        _kdjInforLayer = nil;
    }
}

#pragma mark - property
- (CAShapeLayer *)kdjLayer {
    if (!_kdjLayer) {
        _kdjLayer = [CAShapeLayer layer];
        _kdjLayer.frame = self.p_frame;
        _kdjLayer.fillColor = ZLClearColor.CGColor;
        _kdjLayer.lineWidth = LINEWIDTH;
    }
    return _kdjLayer;
}

- (CAShapeLayer *)kdjInforLayer {
    if (!_kdjInforLayer) {
        _kdjInforLayer = [CAShapeLayer layer];
        _kdjInforLayer.frame = self.p_frame;
        _kdjInforLayer.fillColor = ZLClearColor.CGColor;
        _kdjInforLayer.lineWidth = LINEWIDTH;
    }
    return _kdjInforLayer;
}

//- (CATextLayer *)bSublayer {
//    if (!_bSublayer) {
//        _bSublayer = [CATextLayer layer];
//        _bSublayer.contentsScale = [UIScreen mainScreen].scale;
//        _bSublayer.fontSize = BollTitleFontSize;
//        _bSublayer.alignmentMode = kCAAlignmentJustified;
//    }
//    return _bSublayer;
//}
//
//- (CATextLayer *)tSublayer {
//    if (!_tSublayer) {
//        _tSublayer = [CATextLayer layer];
//        _tSublayer.contentsScale = [UIScreen mainScreen].scale;
//        _tSublayer.fontSize = BollTitleFontSize;
//        _tSublayer.alignmentMode = kCAAlignmentJustified;
//    }
//    return _tSublayer;
//}
//
//- (CATextLayer *)mSublayer {
//    if (!_mSublayer) {
//        _mSublayer = [CATextLayer layer];
//        _mSublayer.contentsScale = [UIScreen mainScreen].scale;
//        _mSublayer.fontSize = BollTitleFontSize;
//        _mSublayer.alignmentMode = kCAAlignmentJustified;
//    }
//    return _mSublayer;
//}
//
//- (CATextLayer *)bollSublayer {
//    if (!_bollSublayer) {
//        _bollSublayer = [CATextLayer layer];
//        _bollSublayer.contentsScale = [UIScreen mainScreen].scale;
//        _bollSublayer.fontSize = BollTitleFontSize;
//        _bollSublayer.alignmentMode = kCAAlignmentJustified;
//    }
//    return _bollSublayer;
//}

- (CAShapeLayer *)getKDJByDataPack:(ZLGuideDataPack *)dataPack {
    CGFloat aHigherValue = [self.delegate aHigherValueInPainter:self];
    //    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat unitValue = [self.delegate painter:self aunitByDValue:self.p_height];
    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
    CGFloat firstCandleX = [self.dataSource firstCandleXInPainter:self];

    NSArray *guideArray = dataPack.dataArray;
    ZLKDJParam *kdjParams = (ZLKDJParam *)dataPack.param;

    UIBezierPath *kPath = [UIBezierPath bezierPath];
    kPath.lineWidth = LINEWIDTH;
    UIBezierPath *dPath = [UIBezierPath bezierPath];
    dPath.lineWidth = LINEWIDTH;
    UIBezierPath *jPath = [UIBezierPath bezierPath];
    jPath.lineWidth = LINEWIDTH;

    CAShapeLayer *kLayer = [CAShapeLayer layer];
    kLayer.frame = self.p_bounds;
    kLayer.fillColor = ZLClearColor.CGColor;
    kLayer.strokeColor = kdjParams.kColor.CGColor;

    CAShapeLayer *dLayer = [CAShapeLayer layer];
    dLayer.frame = self.p_bounds;
    dLayer.fillColor = ZLClearColor.CGColor;
    dLayer.strokeColor = kdjParams.dColor.CGColor;

    CAShapeLayer *jLayer = [CAShapeLayer layer];
    jLayer.frame = self.p_bounds;
    jLayer.fillColor = ZLClearColor.CGColor;
    jLayer.strokeColor = kdjParams.jColor.CGColor;

    BOOL isHead = YES;
    for (int i = 0; i < guideArray.count; i++) {
        ZLGuideKDJModel *model = guideArray[i];

        CGFloat leftX = firstCandleX + cellWidth * i;
        leftX += candleLeftAdge(cellWidth);
        leftX += candleWidth(cellWidth) / 2;

        CGFloat kY = (aHigherValue - model.kData) / unitValue;
        CGFloat dY = (aHigherValue - model.dData) / unitValue;
        CGFloat jY = (aHigherValue - model.jData) / unitValue;
        if (isHead) {
            [kPath moveToPoint:CGPointMake(leftX, kY)];
            [dPath moveToPoint:CGPointMake(leftX, dY)];
            [jPath moveToPoint:CGPointMake(leftX, jY)];
            isHead = NO;
        } else {
            [kPath addLineToPoint:CGPointMake(leftX, kY)];
            [dPath addLineToPoint:CGPointMake(leftX, dY)];
            [jPath addLineToPoint:CGPointMake(leftX, jY)];
        }
    }

    CAShapeLayer *kdjLayer = [CAShapeLayer layer];
    kdjLayer.frame = self.p_bounds;

    kLayer.strokeColor = kdjParams.kColor.CGColor;
    kLayer.path = kPath.CGPath;
    [kPath removeAllPoints];
    [kdjLayer addSublayer:kLayer];

    dLayer.strokeColor = kdjParams.dColor.CGColor;
    dLayer.path = dPath.CGPath;
    [dPath removeAllPoints];
    [kdjLayer addSublayer:dLayer];

    jLayer.strokeColor = kdjParams.jColor.CGColor;
    jLayer.path = jPath.CGPath;
    [jPath removeAllPoints];
    [kdjLayer addSublayer:jLayer];

    return kdjLayer;
}
//
//- (CAShapeLayer *)getBollBandByDataPack:(ZLGuideDataPack *)dataPack {
//    CGFloat sHigherPrice = [self.delegate sHigherPriceInPainter:self];
//    //    CGFloat unitValue = [self.delegate unitValueInPainter:self];
//    CGFloat unitValue = [self.delegate painter:self sunitByDValue:self.p_height];
//    CGFloat cellWidth = [self.delegate cellWidthInPainter:self];
//    CGFloat firstCandleX = [self.dataSource firstCandleXInPainter:self];
//
//    NSArray *guideArray = dataPack.dataArray;
//    ZLBOLLParam *bollParams = (ZLBOLLParam *)dataPack.param;
//
//    UIBezierPath *bandPath = [UIBezierPath bezierPath];
//    bandPath.lineWidth = LINEWIDTH;
//
//    CAShapeLayer *bandShapeLayer = [CAShapeLayer layer];
//    bandShapeLayer.frame = self.p_bounds;
//    bandShapeLayer.strokeColor = ZLClearColor.CGColor;
//    bandShapeLayer.fillColor = bollParams.bandColor.CGColor;
//
//    NSMutableArray *tUpArray = [[NSMutableArray alloc] init];
//    NSMutableArray *tLowArray = [[NSMutableArray alloc] init];
//
//    for (int i = 0; i < guideArray.count; i++) {
//        ZLGuideBOLLModel *model = guideArray[i];
//        if (!model.isNeedDraw) continue;
//
//        CGFloat leftX = firstCandleX + cellWidth * i;
//        leftX += candleLeftAdge(cellWidth);
//        leftX += candleWidth(cellWidth) / 2;
//
//        CGFloat upY = (sHigherPrice - model.upData) / unitValue;
//        CGFloat lowY = (sHigherPrice - model.lowData) / unitValue;
//
//        [tUpArray addObject:[NSValue valueWithCGPoint:CGPointMake(leftX, upY)]];
//        [tLowArray addObject:[NSValue valueWithCGPoint:CGPointMake(leftX, lowY)]];
//    }
//
//    for (int i = 0; i < tUpArray.count; i++) {
//        if (i == 0) {
//            [bandPath moveToPoint:[tUpArray[i] CGPointValue]];
//        } else {
//            [bandPath addLineToPoint:[tUpArray[i] CGPointValue]];
//        }
//    }
//
//    for (int i = (int)tLowArray.count - 1; i >=0; i--) {
//        [bandPath addLineToPoint:[tLowArray[i] CGPointValue]];
//    }
//
//    bandShapeLayer.path = bandPath.CGPath;
//    [bandPath removeAllPoints];
//
//    return bandShapeLayer;
//}

- (void)p_clear {
    [self releaseKDJLayer];
    [self releaseKDJInforLayer];
}

@end
