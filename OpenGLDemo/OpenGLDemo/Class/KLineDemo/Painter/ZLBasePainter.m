//
//  ZLBasePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLBasePainter.h"

@interface ZLBasePainter()

@property (nonatomic, weak) UIView *paintView;

@end

@implementation ZLBasePainter

- (instancetype)initWithPaintView:(UIView *)paintView {
    if (self = [super init]) {
        self.paintView = paintView;
        [self p_initDefault];
    }
    return self;
}

#pragma mark - ZLKLinePainter
- (void)draw {
    // abstract 子类实现
}

// pan
- (void)panBeginPoint:(CGPoint)point {}
- (void)panChangePoint:(CGPoint)point {}
- (void)panEndPoint:(CGPoint)point {}

// pinch
- (void)pinchBeginScale:(CGFloat)scale {}
- (void)pinchChangeScale:(CGFloat)scale {}
- (void)pinchEndScale:(CGFloat)scale {}

#pragma mark - private
- (void)p_initDefault {
    // abstract 子类实现
}

- (void)p_clear {
    // abstract 子类实现
}

- (CGFloat)p_height {
    if (![self p_havePaintView]) {
        return 0;
    }
    return self.paintView.height;
}

- (CGFloat)p_width {
    if (![self p_havePaintView]) {
        return 0;
    }
    return self.paintView.width;
}

- (CGRect)p_frame {
    if (![self p_havePaintView]) {
        return CGRectZero;
    }
    return self.paintView.frame;
}

- (CGRect)p_bounds {
    if (![self p_havePaintView]) {
        return CGRectZero;
    }
    return self.paintView.bounds;
}

- (void)p_addSublayer:(CALayer *)sublayer {
    if (![self p_havePaintView]) {
        return;
    }
    [self.paintView.layer addSublayer:sublayer];
}

- (BOOL)p_havePaintView {
    if (!self.paintView) {
        ZLErrorLog(@"error: paintView is nil!!!");
        return NO;
    }
    return YES;
}

#pragma mark - sys
- (void)dealloc {
    [self p_clear];
}

@end
