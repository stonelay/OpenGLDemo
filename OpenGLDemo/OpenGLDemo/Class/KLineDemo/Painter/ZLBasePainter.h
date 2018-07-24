//
//  ZLBasePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKLinePainter.h"

//@class PaintView;

@protocol KLineDataSource<NSObject>
@end

@interface ZLBasePainter : NSObject<ZLKLinePainter>

@property (nonatomic, weak) UIView *paintView;

@property (nonatomic, weak) id<KLineDataSource> dataSource;

@property (nonatomic, assign, readonly) CGFloat p_height;
@property (nonatomic, assign, readonly) CGFloat p_width;
@property (nonatomic, assign, readonly) BOOL p_havePaintView;

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
- (void)p_addSublayer:(CALayer *)sublayer;
- (BOOL)p_havePaintView;

@end
