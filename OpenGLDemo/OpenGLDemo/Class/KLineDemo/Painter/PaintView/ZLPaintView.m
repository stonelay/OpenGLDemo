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

#import "KLineDataCenter.h"

#import "SceneModel.h"
#import "KLineModel.h"


//#define AxisMarginBottom (60 * SCALE)
//#define AxisMarginLeft (30 * SCALE)
#define UninitializedIndex   -1

@interface ZLPaintView()<PaintViewDataSource, PaintViewDelegate>

// ------ scene base ------ //
@property (nonatomic, assign) CGFloat sHigherPrice;   // 当前屏幕最高价
@property (nonatomic, assign) CGFloat sLowerPrice;   // 当前屏幕最低价

@property (nonatomic, assign) CGFloat unitValue;    // 单位点的值

//@property (nonatomic, assign) CGFloat kLineCellSpace;    //cell间隔
@property (nonatomic, assign) CGFloat kLineCellWidth;    //cell宽度

@property (nonatomic, assign) NSInteger oriIndex;   // pan 之前的第一条index
@property (nonatomic, assign) NSInteger curIndex;   // pan 中当前index

// ------ scene candle base ------ //
@property (nonatomic, assign) CGFloat kMinScale;     //最小缩放量
@property (nonatomic, assign) CGFloat kMaxScale;     //最大缩放量

@property (nonatomic, assign) NSInteger arrayMaxCount; // 最大展示个数
@property (nonatomic, assign) NSInteger showCount; // 当前页面显示的个数

@property (nonatomic, assign) CGFloat oriXScale;      // pinch 之前缩放比例
@property (nonatomic, assign) CGFloat curXScale;      // pinch 中当前缩放比例

// ------ scene cross base ------ //
@property (nonatomic, assign) CGPoint longPressPoint;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, strong) NSArray *curShowArray; // 当前显示队列

@property (nonatomic, strong) NSMutableArray *drawDataArray; //


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
    
    self.kLineCellWidth = 16 * SCALE;    //cell宽度
    
    self.kMinScale = 0.1;     //最小缩放量
    self.kMaxScale = 4.0;     //最大缩放量
    
    self.oriXScale = 1.0;
    self.oriIndex = UninitializedIndex;
    
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 60 * SCALE, 0);
}

- (void)loadData {
    self.drawDataArray = [KLineDataCenter shareInstance].hisKLineDataArray;
    [self prepareDrawWithPoint:CGPointZero andScale:1.0];
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
        
        _painterArray = [tempArray copy];
    }
    return _painterArray;
}

- (void)draw {
    if (self.painterArray && self.painterArray.count != 0) {
        for (int i = 0; i < self.painterArray.count; i++) {
            [self.painterArray[i] draw];
        }
    }
}

#pragma mark - data fix
- (void)prepareDrawWithPoint:(CGPoint)point andScale:(CGFloat)scale {
    [self fixScale:scale];
    [self fixShowCount];
    [self fixBeginIndexWithPoint:point];
    [self fixShowData];
    [self fixMaximum];
}

// 计算 缩放比例
- (void)fixScale:(CGFloat)scale {
    CGFloat curScale = self.oriXScale * scale;
    curScale = MAX(curScale, self.kMinScale);
    curScale = MIN(curScale, self.kMaxScale);
    
    self.curXScale = curScale;
}

// 计算 要显示几个
- (void)fixShowCount {
    self.arrayMaxCount = self.drawDataArray.count;
    NSInteger showCount = self.width / (self.kLineCellWidth * self.curXScale);
    self.showCount = MIN(self.arrayMaxCount, showCount);
}

// 计算 从第几个开始显示
- (void)fixBeginIndexWithPoint:(CGPoint)point {
    if (self.oriIndex == UninitializedIndex) {
        NSInteger beginIndex = self.arrayMaxCount - self.showCount;
        self.oriIndex = MAX(beginIndex, 0);//初始化偏移位置
    }
    
    CGFloat cellWidth = (self.kLineCellWidth * self.curXScale);
    self.curIndex = self.oriIndex - point.x / cellWidth;
}

- (void)fixShowData {
    NSInteger maxValue = self.arrayMaxCount - self.showCount;
    NSInteger minValue = 0;
    self.curIndex = MIN(self.curIndex, maxValue);
    self.curIndex = MAX(self.curIndex, minValue);
    
    self.curShowArray = [self.drawDataArray subarrayWithRange:NSMakeRange(self.curIndex, self.showCount)];
}

// 计算最高最低 和 单位值
- (void)fixMaximum {
    self.sLowerPrice = FLT_MAX;
    self.sHigherPrice = 0;

    for (KLineModel *model in self.curShowArray) {
        self.sHigherPrice = MAX(model.high, self.sHigherPrice);
        self.sLowerPrice = MIN(model.low, self.sLowerPrice);
    }

    // 预留屏幕上下空隙
    self.sLowerPrice *= kLScale;
    self.sHigherPrice *= kHScale;

    // 计算每个点代表的值是多少
    self.unitValue = (self.sHigherPrice - self.sLowerPrice) / (self.height - self.edgeInsets.bottom);
}

#pragma mark - PaintDataSource
- (NSUInteger)maxNumberInPainter:(ZLBasePainter *)painter {
    return self.drawDataArray.count;
}

- (NSUInteger)showNumberInPainter:(ZLBasePainter *)painter {
    return self.showCount;
}

- (NSArray *)showArrayInPainter:(ZLBasePainter *)painter {
    return self.curShowArray;
}

- (KLineModel *)painter:(ZLBasePainter *)painter dataAtIndex:(NSUInteger)index {
    return self.curShowArray[index];
}

- (BOOL)isShowAllInPainter:(ZLBasePainter *)painter {
    return self.drawDataArray.count == self.showCount;
}

- (CGPoint)longPressPointInPainter:(ZLBasePainter *)painter {
    return self.longPressPoint;
}

#pragma mark - paitview delegate
- (CGFloat)cellWidthInPainter:(ZLBasePainter *)painter {
    return self.kLineCellWidth * self.curXScale;
}

- (UIEdgeInsets)edgeInsetsInPainter:(ZLBasePainter *)painter {
    return self.edgeInsets;
}

- (CGFloat)sHigherInPainter:(ZLBasePainter *)painter {
    return self.sHigherPrice;
}

- (CGFloat)sLowerInPainter:(ZLBasePainter *)painter {
    return self.sLowerPrice;
}

- (CGFloat)unitValueInPainter:(ZLBasePainter *)painter {
    return self.unitValue;
}

#pragma mark - override
// pan
- (void)panBeganPoint:(CGPoint)point {
    self.oriIndex = self.curIndex;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panChangedPoint:(CGPoint)point {
    [self prepareDrawWithPoint:point andScale:1.0];
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}
- (void)panEndedPoint:(CGPoint)point {
    self.oriIndex = self.curIndex;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:point]];
}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {
    self.oriXScale = self.curXScale;
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchChangedScale:(CGFloat)scale {
    [self prepareDrawWithPoint:CGPointZero andScale:scale];
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}
- (void)pinchEndedScale:(CGFloat)scale {
    self.oriXScale = self.curXScale;
    [self doInterfaceMethod:_cmd andData:[NSNumber numberWithFloat:scale]];
}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {
    self.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressChangedLocation:(CGPoint)location {
    self.longPressPoint = location;
    [self doInterfaceMethod:_cmd andData:[NSValue valueWithCGPoint:location]];
}
- (void)longPressEndedLocation:(CGPoint)location {
    self.longPressPoint = CGPointZero;
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
