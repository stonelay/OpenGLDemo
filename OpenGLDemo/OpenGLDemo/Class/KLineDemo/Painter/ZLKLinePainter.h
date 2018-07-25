//
//  ZLKLinePainter.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLKLinePainter <NSObject>

- (void)draw;

// pan
- (void)panBeginPoint:(CGPoint)point;
- (void)panChangePoint:(CGPoint)point;
- (void)panEndPoint:(CGPoint)point;

// pinch
- (void)pinchBeginScale:(CGFloat)scale;
- (void)pinchChangeScale:(CGFloat)scale;
- (void)pinchEndScale:(CGFloat)scale;

@end
