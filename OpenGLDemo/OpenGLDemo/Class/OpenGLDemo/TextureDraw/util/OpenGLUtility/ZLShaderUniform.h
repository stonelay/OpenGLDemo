//
//  ZLShaderUniform.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLShaderUniform : NSObject

@property (nonatomic, assign) GLuint uniformId;
@property (nonatomic, strong) NSString *uniformName;

+ (instancetype)uniformWithId:(GLuint)uniformId uniformName:(NSString *)uniformName;

@end
