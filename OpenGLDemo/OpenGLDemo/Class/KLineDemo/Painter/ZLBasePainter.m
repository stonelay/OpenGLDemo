//
//  ZLBasePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLBasePainter.h"

@interface ZLBasePainter()

@property (nonatomic, assign) CGFloat bMargin; // 底部距离
@property (nonatomic, weak) UIView *paintView;

@end

@implementation ZLBasePainter

- (instancetype)initWithPaintView:(UIView *)paintView withBMargin:(CGFloat)bMargin {
    if (self = [super init]) {
        self.bMargin = bMargin;
        self.paintView = paintView;
        [self p_initDefault];
    }
    return self;
}

#pragma mark - ZLKLinePainter
- (void)draw {
    [self p_havePaintView];
    [self p_haveDataSource];
}

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {}
- (void)longPressChangedLocation:(CGPoint)location {}
- (void)longPressEndedLocation:(CGPoint)location {}

#pragma mark - private
- (void)p_initDefault {
    // abstract 子类实现
}

- (void)p_clear {
    // abstract 子类实现
}

- (CGFloat)p_height {
    [self p_havePaintView];
    return self.paintView.height - self.bMargin;
}

- (CGFloat)p_width {
    [self p_havePaintView];
    return self.paintView.width;
}

- (CGRect)p_frame {
    [self p_havePaintView];
    CGRect frame = self.paintView.frame;
    frame.size.height -= self.bMargin;
    return frame;
}

- (CGRect)p_bounds {
    [self p_havePaintView];
    CGRect bounds = self.paintView.bounds;
    bounds.size.height -= self.bMargin;
    return bounds;
}

- (void)p_addSublayer:(CALayer *)sublayer {
    [self p_havePaintView];
    [self.paintView.layer addSublayer:sublayer];
}

- (void)p_havePaintView {
    NSAssert(self.paintView, @"paintView is nil!!!");
}

- (void)p_haveDataSource {
    NSAssert(self.dataSource, @"dataSource is nil!!!");
}

#pragma mark - sys
- (void)dealloc {
    [self p_clear];
}

@end
