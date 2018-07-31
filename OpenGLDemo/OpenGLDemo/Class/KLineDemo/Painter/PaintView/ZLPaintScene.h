//
//  ZLPaintScene.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/30.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLGuideDataPack.h"

#import "ZLPaintView.h"

@interface ZLPaintScene : NSObject


// ------ scene base ------ //
@property (nonatomic, assign, readonly) CGFloat sHigherPrice;   // 当前屏幕最高价
@property (nonatomic, assign, readonly) CGFloat sLowerPrice;   // 当前屏幕最低价

@property (nonatomic, assign, readonly) CGFloat unitValue;    // 单位点的值

@property (nonatomic, assign, readonly) CGFloat cellWidth;

@property (nonatomic, assign, readonly) BOOL isShowAll;

// ------ scene candle base ------ //
@property (nonatomic, assign, readonly) NSInteger arrayMaxCount; // 最大展示个数
@property (nonatomic, assign, readonly) NSInteger showCount; // 当前页面显示的个数

// ------ scene cross base ------ //
@property (nonatomic, assign) CGPoint longPressPoint;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGSize viewPort;

@property (nonatomic, strong, readonly) NSArray *curShowArray; // 当前显示队列

@property (nonatomic, strong) NSMutableArray *drawDataArray; //

@property (nonatomic, assign) ZLKLinePainterOp linePainterOp;

- (void)editIndex;
- (void)editScale;

- (void)prepareDrawWithPoint:(CGPoint)point andScale:(CGFloat)scale;

#pragma mark - property
- (ZLGuideDataPack *)getMADataPackByKey:(NSString *)key;
- (ZLGuideDataPack *)getBOLLDataPack;

@end
