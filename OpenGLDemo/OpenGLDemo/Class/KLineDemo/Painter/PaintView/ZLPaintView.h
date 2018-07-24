//
//  ZLPaintView.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKLinePainter.h"

typedef NS_OPTIONS(NSUInteger, ZLKLinePainterOp) {
    ZLKLinePainterOpNone                        = 0,
    ZLKLinePainterOpGride                       = 1 << 0,
    ZLKLinePainterOpCandle                      = 1 << 1,
    ZLKLinePainterOpMA                          = 1 << 2,
};

@interface ZLPaintView : UIControl<ZLKLinePainter>

@property (nonatomic, assign) ZLKLinePainterOp linePainterOp;
@property (nonatomic, strong) NSArray<ZLKLinePainter> *painterArray;

@end
