//
//  ZLPaintAssistScene.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/8/2.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLPaintAssistScene.h"

#import "ZLGridePainter.h"

#import "ZLKDJPainter.h"


#import "ZLQuoteDataCenter.h"

#import "KLineModel.h"

#import "ZLGuideDataType.h"
#import "ZLPaintCore.h"

#define UninitializedIndex   -1

#define MAEDGEINSETS UIEdgeInsetsMake(60 * SCALE, 10 * SCALE, 60 * SCALE, 10 * SCALE)
#define BOLLEDGEINSETS UIEdgeInsetsMake(40 * SCALE, 10 * SCALE, 60 * SCALE, 10 * SCALE)
#define NONEEDGEINSETS UIEdgeInsetsMake(10 * SCALE, 10 * SCALE, 60 * SCALE, 10 * SCALE)

@interface ZLPaintAssistScene()<PaintViewDataSource, PaintViewDelegate, ZLKLinePainter>

@property (nonatomic, strong) ZLGridePainter *gridePainter;

@property (nonatomic, strong) NSDictionary *assistPainters; // <key, painter>

@end

@implementation ZLPaintAssistScene
- (ZLGridePainter *)gridePainter {
    if (!_gridePainter) {
        _gridePainter = [[ZLGridePainter alloc] initWithPaintView:self];
        _gridePainter.paintOp = ZLGridePaintShowAll;
        _gridePainter.dataSource = self;
        _gridePainter.delegate = self;
    }
    return _gridePainter;
}

- (NSDictionary *)assistPainters {
    if (!_assistPainters) {
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];

        // KDJ
        ZLBasePainter *kdjPainter = [[ZLKDJPainter alloc] initWithPaintView:self];
        kdjPainter.dataSource = self;
        kdjPainter.delegate = self;
        [tDic setObject:kdjPainter forKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        
        _assistPainters = [tDic copy];
    }
    return _assistPainters;
}

- (void)draw {
    [self.paintCore prepareDrawWithPoint:CGPointZero andScale:1.0];
    [self doInterfaceMethod:_cmd andData:nil];
}

- (void)clear {}

#pragma mark - PaintDataSource
- (NSUInteger)maxNumberInPainter:(ZLBasePainter *)painter {
    return self.paintCore.arrayMaxCount;
}

- (NSUInteger)showNumberInPainter:(ZLBasePainter *)painter {
    return self.paintCore.showCount;
}

- (NSArray *)showArrayInPainter:(ZLBasePainter *)painter {
    return self.paintCore.curShowArray;
}

- (KLineModel *)painter:(ZLBasePainter *)painter dataAtIndex:(NSUInteger)index {
    return self.paintCore.curShowArray[index];
}

- (BOOL)isShowAllInPainter:(ZLBasePainter *)painter {
    return self.paintCore.isShowAll;
}

- (CGPoint)longPressPointInPainter:(ZLBasePainter *)painter {
    return self.paintCore.longPressPoint;
}

- (NSInteger)longPressIndexInPainter:(ZLBasePainter *)painter {
    return self.paintCore.longPressIndex;
}

- (CGFloat)firstCandleXInPainter:(ZLBasePainter *)painter {
    return self.paintCore.firstCandleX;
}

- (ZLGuideDataPack *)kdjDataPackInPainter:(ZLBasePainter *)painter {
    return [self.paintCore getKDJDataPack];
}

#pragma mark - paitview delegate
- (CGFloat)cellWidthInPainter:(ZLBasePainter *)painter {
    return self.paintCore.cellWidth;
}

- (UIEdgeInsets)edgeInsetsInPainter:(ZLBasePainter *)painter {
    return self.degeInsets;
}

- (CGFloat)sHigherPriceInPainter:(ZLBasePainter *)painter {
    return self.paintCore.sHigherPrice;
}

- (CGFloat)sLowerPriceInPainter:(ZLBasePainter *)painter {
    return self.paintCore.sLowerPrice;
}

- (CGFloat)aHigherValueInPainter:(ZLBasePainter *)painter {
    return self.paintCore.aHigherValue;
}

- (CGFloat)aLowerValueInPainter:(ZLBasePainter *)painter {
    return self.paintCore.aLowerValue;
}

//- (CGFloat)unitValueInPainter:(ZLBasePainter *)painter {
//    return self.paintCore.unitValue;
//}

- (CGFloat)painter:(ZLBasePainter *)painter sunitByDValue:(CGFloat)dValue {
    return (self.paintCore.sHigherPrice - self.paintCore.sLowerPrice) / dValue;
}

- (CGFloat)painter:(ZLBasePainter *)painter aunitByDValue:(CGFloat)dValue {
    return (self.paintCore.aHigherValue - self.paintCore.aLowerValue) / dValue;
}

#pragma mark - override
// tap
- (void)tapAtPoint:(CGPoint)point {
    [self tapNextAssistType];
    [self draw];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}

// pan
- (void)panBeganPoint:(CGPoint)point {
    [self.paintCore editIndex];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panChangedPoint:(CGPoint)point {
    [self.paintCore prepareDrawWithPoint:point andScale:1.0];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panEndedPoint:(CGPoint)point {
    [self.paintCore editIndex];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {
    [self.paintCore editScale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchChangedScale:(CGFloat)scale {
    [self.paintCore prepareDrawWithPoint:CGPointZero andScale:scale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchEndedScale:(CGFloat)scale {
    [self.paintCore editScale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    self.paintCore.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressChangedLocation:(CGPoint)location {
    self.paintCore.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressEndedLocation:(CGPoint)location {
    self.paintCore.longPressPoint = CGPointZero;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}

- (void)doInterfaceMethod:(SEL)methodName andData:(id)data {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    [self.gridePainter performSelector:methodName withObject:data];
//    [self.candlePainter performSelector:methodName withObject:data];
    
    // main
//    if (self.paintCore.paintMainType & GuidePaintMainTypeMA) {
//        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeMA]];
//        if (mainPainter) { [mainPainter performSelector:methodName withObject:data]; }
//    }
//
//    if (self.paintCore.paintMainType & GuidePaintMainTypeBOLL) {
//        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeBOLL]];
//        if (mainPainter) { [mainPainter performSelector:methodName withObject:data]; }
//    }
    
    // TODO add other main
    
    // assist
    if (self.paintCore.paintAssistType & GuidePaintAssistTypeKDJ) {
        ZLBasePainter *assistPainter = [self.assistPainters objectForKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        if (assistPainter) { [assistPainter performSelector:methodName withObject:data]; }
    }
    
    // TODO add other assist
    
#pragma clang diagnostic pop
}

#pragma mark - private
//- (void)tapNextMainType {
//    if (self.paintCore.paintMainType & GuidePaintMainTypeMA) {
//        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeMA]];
//        [mainPainter clear];
//    }
//
//    if (self.paintCore.paintMainType & GuidePaintMainTypeBOLL) {
//        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeBOLL]];
//        [mainPainter clear];
//    }
//
//    self.paintCore.paintMainType = [ZLGuideDataType getNextMainType:self.paintCore.paintMainType];
//
//    //    if (self.paintCore.paintMainType & GuidePaintMainTypeBOLL) {
//    //        self.paintCore.edgeInsets = BOLLEDGEINSETS;
//    //    }
//    //    if (self.paintCore.paintMainType & GuidePaintMainTypeMA) {
//    //        self.paintCore.edgeInsets = MAEDGEINSETS;
//    //    }
//    //    if (self.paintCore.paintMainType == GuidePaintMainTypeNone) {
//    //        self.paintCore.edgeInsets = NONEEDGEINSETS;
//    //    }
//}

- (void)tapNextAssistType {
    
}

@end
