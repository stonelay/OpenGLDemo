//
//  ZLMAPainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/27.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLMAPainter.h"

#define MA1Color ZLHEXCOLOR(0x191970)

@interface ZLMAPainter()

@property (nonatomic, strong) CAShapeLayer *ma1Layer;

@end

@implementation ZLMAPainter


- (void)p_initDefault {
    [super p_initDefault];
    
    self.ma1Layer.strokeColor = MA1Color.CGColor;
}

#pragma mark - override
- (void)draw {
    [super draw];
    [self drawMA1];
}

// pan
- (void)panBeganPoint:(CGPoint)point {}
- (void)panChangedPoint:(CGPoint)point {
    [self drawMA1];
}
- (void)panEndedPoint:(CGPoint)point {}

// pinch
- (void)pinchBeganScale:(CGFloat)scale {}
- (void)pinchChangedScale:(CGFloat)scale {
    [self drawMA1];
}
- (void)pinchEndedScale:(CGFloat)scale {}

// longPress
- (void)longPressBeganLocation:(CGPoint)location {}
- (void)longPressChangedLocation:(CGPoint)location {}
- (void)longPressEndedLocation:(CGPoint)location {}

#pragma mark - draw
- (void)drawMA1 {
    [self releaseMA1Layer];
    
    
    [self p_addSublayer:self.ma1Layer];
}

#pragma mark - release
- (void)releaseMA1Layer{
    if (_ma1Layer) {
        [_ma1Layer removeFromSuperlayer];
        _ma1Layer = nil;
    }
}

#pragma mark - property
- (CAShapeLayer *)ma1Layer {
    if (!_ma1Layer) {
        _ma1Layer = [CAShapeLayer layer];
        _ma1Layer.frame = CGRectMake(0, 0, self.p_width, self.p_height);
        _ma1Layer.fillColor = ZLClearColor.CGColor;
        _ma1Layer.lineWidth = LINEWIDTH;
    }
    return _ma1Layer;
}


@end
