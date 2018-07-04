//
//  ZLGLProgram.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

// 简单封装 program, 方便使用
@interface ZLGLProgram : NSObject

@property (nonatomic, assign) GLuint programId; // gl 句柄
@property (nonatomic, strong) NSString *vShaderFile; // vertex
@property (nonatomic, strong) NSString *fShaderFile; // fragment

@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSMutableDictionary *uniforms;

- (void)addAttribute:(NSString *)attributeName;
- (GLuint)attributeID:(NSString *)attributeName;

- (void)addUniform:(NSString *)uniformName;
- (GLuint)uniformID:(NSString *)uniformName;

- (BOOL)compileAndLink;
- (void)useProgrm;

@end
