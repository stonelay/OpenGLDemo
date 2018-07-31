//
//  ZLPaintView.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLPaintView.h"

#import "ZLGridePainter.h"
#import "ZLCandlePainter.h"
#import "ZLMAPainter.h"
#import "ZLBOLLPainter.h"

#import "ZLQuoteDataCenter.h"

#import "SceneModel.h"
#import "KLineModel.h"

#import "ZLPaintScene.h"

#define UninitializedIndex   -1

@interface ZLPaintView()<PaintViewDataSource, PaintViewDelegate>

@property (nonatomic, strong) ZLPaintScene *paintScene;

@end

@implementation ZLPaintView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefault];
        [self loadData];
    }
    return self;
}

- (void)initDefault {
    [super initDefault];
    self.backgroundColor = ZLGray(234);
    
    self.paintScene = [[ZLPaintScene alloc] init];
}

- (void)loadData {
    self.paintScene.edgeInsets = UIEdgeInsetsMake(40 * SCALE, 10 * SCALE, 60 * SCALE, 10 * SCALE);
    
    // TODO drawDataArray is nil 返回异常
    self.paintScene.drawDataArray = [ZLQuoteDataCenter shareInstance].hisKLineDataArray;
//    [self.paintScene setViewPort:self.bounds.size];
    self.paintScene.viewPort = self.bounds.size;
}

- (NSArray *)painterArray {
    if (!_painterArray) {
        NSMutableArray *tempArray = [NSMutableArray new];
        if (self.linePainterOp & ZLKLinePainterOpGride) {
            ZLBasePainter *painter = [[ZLGridePainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            painter.delegate = self;
            [tempArray addObject:painter];
        }
        
        if (self.linePainterOp & ZLKLinePainterOpCandle) {
            ZLBasePainter *painter = [[ZLCandlePainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            painter.delegate = self;
            [tempArray addObject:painter];
        }
        
        if (self.linePainterOp & ZLKLinePainterOpMA) {
            ZLBasePainter *painter = [[ZLMAPainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            painter.delegate = self;
            [tempArray addObject:painter];
        }
        
        if (self.linePainterOp & ZLKLinePainterOpBOLL) {
            ZLBasePainter *painter = [[ZLBOLLPainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            painter.delegate = self;
            [tempArray addObject:painter];
        }
        
        _painterArray = [tempArray copy];
    }
    return _painterArray;
}

- (void)setLinePainterOp:(ZLKLinePainterOp)linePainterOp {
    _linePainterOp = linePainterOp;
    // TODO
    self.paintScene.linePainterOp = linePainterOp;
}

- (void)draw {
    [self.paintScene prepareDrawWithPoint:CGPointZero andScale:1.0];
    if (self.painterArray && self.painterArray.count != 0) {
        for (int i = 0; i < self.painterArray.count; i++) {
            [self.painterArray[i] draw];
        }
    }
}

#pragma mark - PaintDataSource
- (NSUInteger)maxNumberInPainter:(ZLBasePainter *)painter {
    return self.paintScene.arrayMaxCount;
}

- (NSUInteger)showNumberInPainter:(ZLBasePainter *)painter {
    return self.paintScene.showCount;
}

- (NSArray *)showArrayInPainter:(ZLBasePainter *)painter {
    return self.paintScene.curShowArray;
}

- (KLineModel *)painter:(ZLBasePainter *)painter dataAtIndex:(NSUInteger)index {
    return self.paintScene.curShowArray[index];
}

- (BOOL)isShowAllInPainter:(ZLBasePainter *)painter {
    return self.paintScene.isShowAll;
}

- (CGPoint)longPressPointInPainter:(ZLBasePainter *)painter {
    return self.paintScene.longPressPoint;
}

- (ZLGuideDataPack *)painter:(ZLBasePainter *)painter dataPackByMA:(NSString *)ma {
    return [self.paintScene getMADataPackByKey:ma];
}

- (ZLGuideDataPack *)bollDataPackInPainter:(ZLBasePainter *)painter {
    return [self.paintScene getBOLLDataPack];
}

#pragma mark - paitview delegate
- (CGFloat)cellWidthInPainter:(ZLBasePainter *)painter {
    return self.paintScene.cellWidth;
}

- (UIEdgeInsets)edgeInsetsInPainter:(ZLBasePainter *)painter {
    return self.paintScene.edgeInsets;
}

- (CGFloat)sHigherInPainter:(ZLBasePainter *)painter {
    return self.paintScene.sHigherPrice;
}

- (CGFloat)sLowerInPainter:(ZLBasePainter *)painter {
    return self.paintScene.sLowerPrice;
}

- (CGFloat)unitValueInPainter:(ZLBasePainter *)painter {
    return self.paintScene.unitValue;
}

#pragma mark - override
// pan
- (void)panBeganPoint:(CGPoint)point {
    [self.paintScene editIndex];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panChangedPoint:(CGPoint)point {
    [self.paintScene prepareDrawWithPoint:point andScale:1.0];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panEndedPoint:(CGPoint)point {
    [self.paintScene editIndex];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {
    [self.paintScene editScale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchChangedScale:(CGFloat)scale {
    [self.paintScene prepareDrawWithPoint:CGPointZero andScale:scale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchEndedScale:(CGFloat)scale {
    [self.paintScene editScale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    self.paintScene.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressChangedLocation:(CGPoint)location {
    self.paintScene.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressEndedLocation:(CGPoint)location {
    self.paintScene.longPressPoint = CGPointZero;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}

- (void)doInterfaceMethod:(SEL)methodName andData:(id)data {
    if (self.painterArray && self.painterArray.count != 0) {
        for (int i = 0; i < self.painterArray.count; i++) {
            [self.painterArray[i] performSelector:methodName withObject:data];
        }
    }
}



@end
