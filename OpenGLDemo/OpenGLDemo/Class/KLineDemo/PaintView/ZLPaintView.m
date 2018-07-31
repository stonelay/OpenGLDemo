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

#import "KLineModel.h"

#import "ZLPaintScene.h"

#import "ZLGuideDataType.h"

#define UninitializedIndex   -1

@interface ZLPaintView()<PaintViewDataSource, PaintViewDelegate>

//@property (nonatomic, assign) GuidePaintMainType paintMainType;
//@property (nonatomic, assign) GuidePaintAssistType paintAssistType;

@property (nonatomic, strong) ZLPaintScene *paintScene;

@property (nonatomic, strong) ZLGridePainter *gridePainter;
@property (nonatomic, strong) ZLCandlePainter *candlePainter;

@property (nonatomic, strong) NSDictionary *mainPainters;   // <key, painter>
@property (nonatomic, strong) NSDictionary *assistPainters; // <key, painter>


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
    self.paintScene.paintMainType = GuidePaintMainTypeMA;
    self.paintScene.paintAssistType = GuidePaintAssistTypeNone;
}

- (void)loadData {
    self.paintScene.edgeInsets = UIEdgeInsetsMake(40 * SCALE, 10 * SCALE, 60 * SCALE, 10 * SCALE);
    
    // TODO drawDataArray is nil 返回异常
    self.paintScene.drawDataArray = [ZLQuoteDataCenter shareInstance].hisKLineDataArray;
    self.paintScene.viewPort = self.bounds.size;
}

- (ZLGridePainter *)gridePainter {
    if (!_gridePainter) {
        _gridePainter = [[ZLGridePainter alloc] initWithPaintView:self];
        _gridePainter.dataSource = self;
        _gridePainter.delegate = self;
    }
    return _gridePainter;
}

- (ZLCandlePainter *)candlePainter {
    if (!_candlePainter) {
        _candlePainter = [[ZLCandlePainter alloc] initWithPaintView:self];
        _candlePainter.dataSource = self;
        _candlePainter.delegate = self;
    }
    return _candlePainter;
}

- (NSDictionary *)mainPainters {
    if (!_mainPainters) {
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];
        
        ZLBasePainter *maPainter = [[ZLMAPainter alloc] initWithPaintView:self];
        maPainter.dataSource = self;
        maPainter.delegate = self;
        [tDic setObject:maPainter forKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeMA]];
        
        ZLBasePainter *bollPainter = [[ZLBOLLPainter alloc] initWithPaintView:self];
        bollPainter.dataSource = self;
        bollPainter.delegate = self;
        [tDic setObject:bollPainter forKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeBOLL]];
        
        _mainPainters = [tDic copy];
    }
    return _mainPainters;
}

- (NSDictionary *)assistPainters {
    if (!_assistPainters) {
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];
        
        // KDJ
        
        _assistPainters = [tDic copy];
    }
    return _assistPainters;
}

- (void)draw {
    [self.paintScene prepareDrawWithPoint:CGPointZero andScale:1.0];
    
    [self doInterfaceMethod:_cmd andData:nil];
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
// tap
- (void)tapAtPoint:(CGPoint)point {
    [self tapNextMainType];
    [self draw];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    [self.gridePainter performSelector:methodName withObject:data];
    [self.candlePainter performSelector:methodName withObject:data];
    
    // main
    if (self.paintScene.paintMainType & GuidePaintMainTypeMA) {
        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeMA]];
        if (mainPainter) { [mainPainter performSelector:methodName withObject:data]; }
    }
    
    if (self.paintScene.paintMainType & GuidePaintMainTypeBOLL) {
        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeBOLL]];
        if (mainPainter) { [mainPainter performSelector:methodName withObject:data]; }
    }
    
    // TODO add other main
    
    // assist
    if (self.paintScene.paintAssistType & GuidePaintAssistTypeKDJ) {
        ZLBasePainter *assistPainter = [self.assistPainters objectForKey:[ZLGuideDataType getNameByPaintAssistType:GuidePaintAssistTypeKDJ]];
        if (assistPainter) { [assistPainter performSelector:methodName withObject:data]; }
    }
    
    // TODO add other assist
    
#pragma clang diagnostic pop
}

#pragma mark - private
- (void)tapNextMainType {
    if (self.paintScene.paintMainType & GuidePaintMainTypeMA) {
        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeMA]];
        [mainPainter clear];
    }
    
    if (self.paintScene.paintMainType & GuidePaintMainTypeBOLL) {
        ZLBasePainter *mainPainter = [self.mainPainters objectForKey:[ZLGuideDataType getNameByPaintMainType:GuidePaintMainTypeBOLL]];
        [mainPainter clear];
    }
    
    self.paintScene.paintMainType = [ZLGuideDataType getNextMainType:self.paintScene.paintMainType];
}

- (void)tapNextAssistType {
    self.paintScene.paintAssistType = [ZLGuideDataType getNextAssistType:self.paintScene.paintAssistType];
}

@end
