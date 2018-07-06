//
//  PanSetting11View.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/6.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawModel.h"
@class GLRender11View;

@interface PanSetting11View : UIView

@property (nonatomic, strong) DrawElement *drawElement;
@property (nonatomic, weak) GLRender11View *renderView;
@end
