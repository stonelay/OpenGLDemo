//
//  ZLShaderAttribute.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLShaderAttribute : NSObject

@property (nonatomic, assign) GLuint attributeId;
@property (nonatomic, strong) NSString *attributeName;

+ (instancetype)attributeWithId:(GLuint)attributeId attributeName:(NSString *)attributeName;


@end
