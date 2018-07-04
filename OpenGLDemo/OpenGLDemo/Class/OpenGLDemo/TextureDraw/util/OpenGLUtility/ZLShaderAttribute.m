//
//  ZLShaderAttribute.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLShaderAttribute.h"

@implementation ZLShaderAttribute

+ (instancetype)attributeWithId:(GLuint)attributeId attributeName:(NSString *)attributeName {
    ZLShaderAttribute *attribute = [[ZLShaderAttribute alloc] init];
    attribute.attributeId = attributeId;
    attribute.attributeName = attributeName;
    return attribute;
}

@end
