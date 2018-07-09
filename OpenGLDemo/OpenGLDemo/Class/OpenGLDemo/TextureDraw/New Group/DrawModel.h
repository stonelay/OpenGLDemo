//
//  DrawModel.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/6.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DrawElement;

@interface DrawModel : NSObject

@property (nonatomic, strong) DrawElement *drawElement;

@property (nonatomic, strong) NSArray *lineArray;

@end

@interface LineModel : NSObject

+ (instancetype)lineWithBeginPoint:(CGPoint)beginPoint
                          endPoint:(CGPoint)endPoint;

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@interface DrawElement : NSObject

@property (nonatomic, assign) CGFloat pointSize;

@property (nonatomic, assign) GLfloat r;
@property (nonatomic, assign) GLfloat g;
@property (nonatomic, assign) GLfloat b;
@property (nonatomic, assign) GLfloat a;

@end


