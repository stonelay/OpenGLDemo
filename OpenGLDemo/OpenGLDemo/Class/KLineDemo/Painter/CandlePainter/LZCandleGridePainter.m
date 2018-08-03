//
//  LZCandleGridePainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/8/3.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "LZCandleGridePainter.h"

@implementation LZCandleGridePainter

- (void)draw {
    [super draw];
}

- (void)drawBorder {
    [super drawBorder];
}
- (void)drawLatitudeLines {
    [super drawLatitudeLines];
}

- (void)drawLongittueLines {
    [super drawLongittueLines];
    
    // 纬线 绘制方式 最高最低， 等分3 四条
    CGFloat sHigherPrice = [self.delegate sHigherPriceInPainter:self];
    CGFloat sLowerPrice = [self.delegate sLowerPriceInPainter:self];
    //    CGFloat unitValue = [self.delegate unitValueInPainter:self];
    CGFloat unitValue = [self.delegate painter:self sunitByDValue:self.p_height];
    
    CGFloat curHigherPrice = sHigherPrice / kHScale;
    CGFloat curLowerPrice = sLowerPrice / kLScale;
    
    CGFloat higherY = (sHigherPrice - curHigherPrice) / unitValue;
    CGFloat lowerY = (sHigherPrice - curLowerPrice) / unitValue;
    
    [self addLongitudeWithPrice:curHigherPrice positionY:higherY];
    [self addLongitudeWithPrice:(curHigherPrice + curLowerPrice) / 3 * 1 positionY:(higherY + lowerY) / 3 * 1];
    [self addLongitudeWithPrice:(curHigherPrice + curLowerPrice) / 3 * 2 positionY:(higherY + lowerY) / 3 * 2];
    [self addLongitudeWithPrice:curLowerPrice positionY:lowerY];
}

@end
