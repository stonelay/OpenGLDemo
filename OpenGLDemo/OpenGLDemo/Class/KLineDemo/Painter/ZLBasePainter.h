//
//  ZLBasePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKLinePainter.h"
#import "KLineModel.h"
#import "ZLGuideDataPack.h"

static const CGFloat kHScale = 1.005;
static const CGFloat kLScale = 0.995;
static const CGFloat kSpaceCellScale = 0.75;// 蜡烛宽度 和 cell 的比例

static CGFloat inline candleWidth(CGFloat cellWidth) {
    return cellWidth * kSpaceCellScale;
}
static CGFloat inline candleLeftAdge(CGFloat cellWidth) {
    return cellWidth * (1 - kSpaceCellScale);
}

@protocol PaintViewDataSource;
@protocol PaintViewDelegate;

@interface ZLBasePainter : NSObject<ZLKLinePainter>

@property (nonatomic, weak) id<PaintViewDataSource> dataSource;
@property (nonatomic, weak) id<PaintViewDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets screenEdgeInsets;

- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (instancetype)initWithPaintView:(UIView *)paintView;


#pragma mark - private
/**
 abstract
 初始化
 **/
- (void)p_initDefault;

- (void)p_clear;

// 实际的
- (CGRect)s_bounds;

// 画布的
- (CGFloat)p_left;
- (CGFloat)p_top;
- (CGFloat)p_height;
- (CGFloat)p_width;
- (CGRect)p_frame;
- (CGRect)p_bounds;
- (void)p_addSublayer:(CALayer *)sublayer;

#pragma mark - data


@end

@protocol PaintViewDataSource<NSObject>

// 最多有多少数据 需要 显示
- (NSUInteger)maxNumberInPainter:(ZLBasePainter *)painter;

// 当前页面 需要显示的count
- (NSUInteger)showNumberInPainter:(ZLBasePainter *)painter;

// 当前页面 需要显示 数据(无参数)
- (NSArray *)showArrayInPainter:(ZLBasePainter *)painter;

// 当前页面 需要显示 数据
//- (NSArray *)painter:(ZLBasePainter *)painter showArrayFrom:(NSUInteger)fIndex length:(NSUInteger)length;

// 当前页面的 单个数据 (index 是showArray index)
- (KLineModel *)painter:(ZLBasePainter *)painter dataAtIndex:(NSUInteger)index;

// 所有数据是否已显示
- (BOOL)isShowAllInPainter:(ZLBasePainter *)painter;

// 
- (CGPoint)longPressPointInPainter:(ZLBasePainter *)painter;
//- (NSUInteger)selectCrossIndexInPainter:(ZLBasePainter *)painter;

- (ZLGuideDataPack *)painter:(ZLBasePainter *)painter dataPackByMA:(NSString *)ma;

@end

@protocol PaintViewDelegate<NSObject>

// 屏幕周边
- (UIEdgeInsets)edgeInsetsInPainter:(ZLBasePainter *)painter;

// 当前屏幕 最高最低价 (有缩放 预留空间)
- (CGFloat)sHigherInPainter:(ZLBasePainter *)painter;
- (CGFloat)sLowerInPainter:(ZLBasePainter *)painter;

// 单个蜡烛线的宽度
- (CGFloat)cellWidthInPainter:(ZLBasePainter *)painter;

// 价格 和 屏幕 像素的单位比
- (CGFloat)unitValueInPainter:(ZLBasePainter *)painter;

@end
