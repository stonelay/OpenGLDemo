//
//  SceneCandleModel.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/26.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "SceneBaseModel.h"

@interface SceneCandleModel : SceneBaseModel

@property (nonatomic, assign) CGFloat kMinScale;     //最小缩放量
@property (nonatomic, assign) CGFloat kMaxScale;     //最大缩放量

@property (nonatomic, assign) NSUInteger arrayMaxCount; // 最大展示个数
@property (nonatomic, assign) NSUInteger showCount; // 当前页面显示的个数

@property (nonatomic, assign) NSInteger oriIndex;   // pan 之前的第一条index
@property (nonatomic, assign) NSInteger curIndex;   // pan 中当前index




@end
