//
//  ZLBasePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKLinePainter.h"
#import "SceneCrossModel.h"
#import "SceneCandleModel.h"

@protocol KLineDataSource;

@interface ZLBasePainter : NSObject<ZLKLinePainter>

@property (nonatomic, weak) id<KLineDataSource> dataSource;

@property (nonatomic, assign, readonly) CGFloat bMargin; // 底部距离

- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (instancetype)initWithPaintView:(UIView *)paintView withBMargin:(CGFloat)bMargin;


#pragma mark - private
/**
 abstract
 初始化
 **/
- (void)p_initDefault;

- (void)p_clear;

// 
- (CGFloat)p_height;
- (CGFloat)p_width;
- (CGRect)p_frame;
- (CGRect)p_bounds;
- (void)p_addSublayer:(CALayer *)sublayer;
//- (void)p_havePaintView;

@end

@protocol KLineDataSource<NSObject>

// 最多有多少数据 需要 显示
//- (NSUInteger)maxNumberInPainter:(ZLBasePainter *)painter;

// 当前页面 需要显示 数据(无参数)
- (NSArray *)showArrayInPainter:(ZLBasePainter *)painter;

// 当前页面 需要显示 数据
- (NSArray *)painter:(ZLBasePainter *)painter showArrayFrom:(NSUInteger)fIndex length:(NSUInteger)length;

// 当前 candle 场景 参数
- (SceneCandleModel *)sceneCandleModelInpainter:(ZLBasePainter *)painter;

// 当前 cross 场景 参数
- (SceneCrossModel *)sceneCrossModelInpainter:(ZLBasePainter *)painter;

@end
