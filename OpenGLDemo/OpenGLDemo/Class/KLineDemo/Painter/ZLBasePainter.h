//
//  ZLBasePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKLinePainter.h"

@protocol KLineDataSource;

@interface ZLBasePainter : NSObject<ZLKLinePainter>

@property (nonatomic, weak) id<KLineDataSource> dataSource;

//@property (nonatomic, assign, readonly) CGFloat p_height;
//@property (nonatomic, assign, readonly) CGFloat p_width;
//@property (nonatomic, assign, readonly) BOOL p_havePaintView;

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

// 
- (CGFloat)p_height;
- (CGFloat)p_width;
- (CGRect)p_frame;
- (CGRect)p_bounds;
- (void)p_addSublayer:(CALayer *)sublayer;
- (BOOL)p_havePaintView;

@end

@protocol KLineDataSource<NSObject>

- (NSUInteger)maxNumberOfPainter:(ZLBasePainter *)painter;
- (NSArray *)paintArrayFrom:(NSUInteger)fIndex length:(NSUInteger)length painter:(ZLBasePainter *)painter;

@end
