//
//  ZLPaintScene.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/30.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLPaintScene.h"
#import "KLineModel.h"
#import "ZLBasePainter.h"

#import "ZLGuideManager.h"

#import "ZLMAParam.h"
#import "ZLBOLLParam.h"

#define UninitializedIndex   -1

@interface ZLPaintScene()

@property (nonatomic, strong) ZLGuideManager *guideManager;

@property (nonatomic, assign) CGFloat sHigherPrice;
@property (nonatomic, assign) CGFloat sLowerPrice;

@property (nonatomic, assign) CGFloat unitValue;
@property (nonatomic, assign) CGFloat kLineCellWidth;    //cell宽度

@property (nonatomic, assign) CGFloat kMinScale;     //最小缩放量
@property (nonatomic, assign) CGFloat kMaxScale;     //最大缩放量

@property (nonatomic, assign) NSInteger oriIndex;   // pan 之前的第一条index
@property (nonatomic, assign) NSInteger curIndex;   // pan 中当前index

@property (nonatomic, assign) CGFloat oriXScale;      // pinch 之前缩放比例
@property (nonatomic, assign) CGFloat curXScale;      // pinch 中当前缩放比例

@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, strong) NSArray *curShowArray;

@end

@implementation ZLPaintScene

- (instancetype)init {
    if (self = [super init]) {
        self.kLineCellWidth = 16 * SCALE;    //cell宽度
        
        self.kMinScale = 0.1;     //最小缩放量
        self.kMaxScale = 4.0;     //最大缩放量
        
        self.oriXScale = 1.0;
        self.oriIndex = UninitializedIndex;
        
        self.guideManager = [[ZLGuideManager alloc] init];
    }
    return self;
}

#pragma mark - scene fix
- (void)prepareDrawWithPoint:(CGPoint)point andScale:(CGFloat)scale {
    if (CGSizeEqualToSize(self.viewPort, CGSizeZero)) {
        NSAssert(NO, @"Invalid viewPort is zero.");
        return;
    }
    if (!self.drawDataArray || self.drawDataArray.count == 0) {
        NSAssert(NO, @"Invalid drawDataArray is nil or count is zero.");
        return;
    }
    
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
    NSInteger showCount = [self z_portWidth] / (self.kLineCellWidth * self.curXScale);
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
    
    if (self.linePainterOp & ZLKLinePainterOpMA) {
        SMaximum *maximum = [self.guideManager getMAMaximunWithRange:NSMakeRange(self.curIndex, self.showCount)];
        self.sHigherPrice = MAX(maximum.max, self.sHigherPrice);
        self.sLowerPrice = MIN(maximum.min, self.sLowerPrice);
    }
    
    if (self.linePainterOp & ZLKLinePainterOpBOLL) {
        SMaximum *maximum = [self.guideManager getBOLLMaximunWithRange:NSMakeRange(self.curIndex, self.showCount)];
        self.sHigherPrice = MAX(maximum.max, self.sHigherPrice);
        self.sLowerPrice = MIN(maximum.min, self.sLowerPrice);
    }
    
    // 预留屏幕上下空隙
    self.sLowerPrice *= kLScale;
    self.sHigherPrice *= kHScale;
    
    // 计算每个点代表的值是多少
    self.unitValue = (self.sHigherPrice - self.sLowerPrice) / [self z_portHeight];
}

#pragma mark - property
- (NSInteger)arrayMaxCount {
    return self.drawDataArray.count;
}

- (BOOL)isShowAll {
    return self.arrayMaxCount == self.showCount;
}

- (CGFloat)cellWidth {
    return self.kLineCellWidth * self.curXScale;
}

- (void)editIndex {self.oriIndex = self.curIndex;}
- (void)editScale {self.oriXScale = self.curXScale;}

- (void)setDrawDataArray:(NSMutableArray *)drawDataArray {
    _drawDataArray = drawDataArray;
    [self.guideManager updateWithChartData:drawDataArray];
}

- (ZLGuideDataPack *)getMADataPackByKey:(NSString *)key {
    ZLGuideDataPack *oDataPack = [self.guideManager getMADataPackByKey:key];
    if (!oDataPack) {
        return nil;
    }

    ZLMAParam *param = (ZLMAParam *)oDataPack.param;
    ZLGuideDataPack *tDataPack = [[ZLGuideDataPack alloc] initWithParams:param];

    tDataPack.dataArray = [oDataPack.dataArray subarrayWithRange:NSMakeRange(self.curIndex, self.showCount)];
    return tDataPack;
}

- (ZLGuideDataPack *)getBOLLDataPack {
    ZLGuideDataPack *oDataPack = [self.guideManager getBOLLDataPack];
    if (!oDataPack) {
        return nil;
    }
    
    ZLBOLLParam *param = (ZLBOLLParam *)oDataPack.param;
    ZLGuideDataPack *tDataPack = [[ZLGuideDataPack alloc] initWithParams:param];
    
    tDataPack.dataArray = [oDataPack.dataArray subarrayWithRange:NSMakeRange(self.curIndex, self.showCount)];
    return tDataPack;
}

- (CGFloat)z_portWidth {
    return self.viewPort.width - self.edgeInsets.left - self.edgeInsets.right;
}

- (CGFloat)z_portHeight {
    return self.viewPort.height - self.edgeInsets.top - self.edgeInsets.bottom;
}

@end
