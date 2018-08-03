//
//  ZLPaintAssistScene.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/8/2.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLPaintAssistScene.h"

#import "ZLKDJGridePainter.h"
#import "ZLKDJPainter.h"
#import "ZLQuoteDataCenter.h"

#import "KLineModel.h"

#import "ZLGuideDataType.h"
#import "ZLPaintCore.h"

#define UninitializedIndex   -1

@interface ZLPaintAssistScene()<PaintViewDelegate, PaintViewDataSource>

@property (nonatomic, strong) NSDictionary *gridePainter;   // <key, gride painter>
@property (nonatomic, strong) NSDictionary *assistPainters; // <key, painter>

@end

@implementation ZLPaintAssistScene

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

- (NSDictionary *)gridePainter {
    if (!_gridePainter) {
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];
        
        // KDJ
        ZLGridePainter *kdjGridePainter = [[ZLKDJGridePainter alloc] initWithPaintView:self];
        kdjGridePainter.paintOp = ZLGridePaintShowAll;
        kdjGridePainter.dataSource = self;
        kdjGridePainter.delegate = self;
        [tDic setObject:kdjGridePainter forKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        
        _gridePainter = [tDic copy];
    }
    return _gridePainter;
}

- (void)draw {
    [self.paintCore prepareDrawWithPoint:CGPointZero andScale:1.0];
    [self doInterfaceMethod:_cmd andData:nil];
}

- (void)clear {}

#pragma mark - assist paint dataSource
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

#pragma mark - assist paitview delegate
- (CGFloat)cellWidthInPainter:(ZLBasePainter *)painter {
    return self.paintCore.cellWidth;
}

- (UIEdgeInsets)edgeInsetsInPainter:(ZLBasePainter *)painter {
    return self.degeInsets;
}

- (CGFloat)aHigherValueInPainter:(ZLBasePainter *)painter {
    return self.paintCore.aHigherValue;
}

- (CGFloat)aLowerValueInPainter:(ZLBasePainter *)painter {
    return self.paintCore.aLowerValue;
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
    // assist
    if (self.paintCore.paintAssistType & GuidePaintAssistTypeKDJ) {
        ZLBasePainter *assistPainter = [self.assistPainters objectForKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        if (assistPainter) { [assistPainter performSelector:methodName withObject:data]; }
        
        ZLBasePainter *gridePainter = [self.gridePainter objectForKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        if (gridePainter) { [gridePainter performSelector:methodName withObject:data]; }
    }
    
    // TODO add other assist
    
#pragma clang diagnostic pop
}

#pragma mark - private

- (void)tapNextAssistType {
    if (self.paintCore.paintAssistType & GuidePaintAssistTypeKDJ) {
        ZLBasePainter *assistPainter = [self.assistPainters objectForKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        [assistPainter clear];
    }
    
    self.paintCore.paintAssistType = [ZLGuideDataType getNextAssistType:self.paintCore.paintAssistType];
    
    if (self.paintCore.paintAssistType & GuidePaintAssistTypeKDJ) {
        UIEdgeInsets dege = self.degeInsets;
        dege.top = getAssistInforHeight(GuidePaintAssistTypeKDJ);
        self.degeInsets = dege;
    }
}

- (void)setPaintCore:(ZLPaintCore *)paintCore {
    _paintCore = paintCore;
    self.degeInsets = UIEdgeInsetsMake(getAssistInforHeight(paintCore.paintAssistType), 0, 30 * SCALE, 0);
}

- (void)setDegeInsets:(UIEdgeInsets)degeInsets {
    _degeInsets = degeInsets;
    self.paintCore.portWidth = self.width - self.degeInsets.left - self.degeInsets.right;
}

@end
