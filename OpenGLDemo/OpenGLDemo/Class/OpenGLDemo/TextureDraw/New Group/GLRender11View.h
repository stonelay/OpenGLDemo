//
//  GLRender11View.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/8.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGLView.h"
//#import "DrawModel.h"
@class DrawElement;

@interface GLRender11View : ZLGLView

@property (nonatomic, strong) DrawElement *drawElement;

- (void)clear;
- (void)replay;
- (void)undo;

@end
