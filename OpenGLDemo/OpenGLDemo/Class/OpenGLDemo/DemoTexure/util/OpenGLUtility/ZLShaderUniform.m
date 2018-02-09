//
//  ZLShaderUniform.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLShaderUniform.h"


@implementation ZLShaderUniform

+ (instancetype)uniformWithId:(GLuint)uniformId uniformName:(NSString *)uniformName {
    ZLShaderUniform *uniform = [[ZLShaderUniform alloc] init];
    uniform.uniformId = uniformId;
    uniform.uniformName = uniformName;
    return uniform;
}

@end
