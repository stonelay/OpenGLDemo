//
//  SceneBaseModel.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/26.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneBaseModel : NSObject

@property (nonatomic, assign) CGFloat sHigherPrice;
@property (nonatomic, assign) CGFloat sLowerPrice;

@property (nonatomic, assign) CGFloat unitValue;

@property (nonatomic, assign) CGFloat kLineCellSpace;
@property (nonatomic, assign) CGFloat kLineCellWidth;

@property (nonatomic, assign) CGFloat curXScale;
@property (nonatomic, assign) CGFloat oriXScale;

@end
