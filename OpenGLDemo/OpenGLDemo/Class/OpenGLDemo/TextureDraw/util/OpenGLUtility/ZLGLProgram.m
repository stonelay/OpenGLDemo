//
//  ZLGLProgram.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGLProgram.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "ZLShaderUniform.h"
#import "ZLShaderAttribute.h"

@interface ZLGLProgram()

@property (nonatomic, strong) NSString *vShaderLog;
@property (nonatomic, strong) NSString *fShaderLog;

@end

@implementation ZLGLProgram

- (instancetype)init {
    if (self = [super init]) {
        _programId = 0;
        
        _attributes = [NSMutableDictionary new];
        _uniforms = [NSMutableDictionary new];
        
        _vShaderFile = nil;
        _fShaderFile = nil;
    }
    return self;
}

// glProgram 管理一份 attributes
// 在link之前addAttribute
- (void)addAttribute:(NSString *)attributeName {
    if ([self.attributes.allKeys containsObject:attributeName]) {
        return;
    }
    GLuint attributeId = (GLuint)self.attributes.allKeys.count;
//    glBindAttribLocation(self.programId, attributeId, [attributeName UTF8String]);
    ZLShaderAttribute *attribute =
    [ZLShaderAttribute attributeWithId:attributeId attributeName:attributeName];
    [self.attributes setObject:attribute forKey:attributeName];
}

- (GLuint)attributeID:(NSString *)attributeName {
    ZLShaderAttribute *attribute = [self.attributes objectForKey:attributeName];
    return attribute.attributeId;
}

// glProgram 管理一份 uniforms
- (void)addUniform:(NSString *)uniformName {
    if ([self.uniforms.allKeys containsObject:uniformName]) {
        return;
    }
//    GLuint uniformId = glGetUniformLocation(self.programId, [uniformName UTF8String]);
    
    ZLShaderUniform *uniform =
    [ZLShaderUniform uniformWithId:-1 uniformName:uniformName];
    [self.uniforms setObject:uniform forKey:uniformName];
}

- (GLuint)uniformID:(NSString *)uniformName {
    ZLShaderUniform *uniform = [self.uniforms objectForKey:uniformName];
    return uniform.uniformId;
}

#pragma mark - compile
- (BOOL)compileAndLink {
    GLuint verShader, fragShader;      //vector 和 fragment shader ID
    self.programId = glCreateProgram();     //创建一个shader program
    
    //创建并且编译 vector shader
    NSString *vShaderPath = [[NSBundle mainBundle] pathForResource:self.vShaderFile ofType:@"glsl"];
    NSString *fShaderPath = [[NSBundle mainBundle] pathForResource:self.fShaderFile ofType:@"glsl"];
    
    if (![self compileShader:&verShader type:GL_VERTEX_SHADER file:vShaderPath]) {
        NSLog(@"vShader compile failed.");
    }
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fShaderPath]) {
        NSLog(@"fShader compile failed.");
    }
    
    //附加 vector 和 fragment shader
    glAttachShader(self.programId, verShader);
    glAttachShader(self.programId, fragShader);
    
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    for (ZLShaderAttribute *attribute in [self.attributes allValues]) {
        glBindAttribLocation(self.programId, attribute.attributeId, [attribute.attributeName UTF8String]);
    }
    
    if (![self linkProgram]) {
        NSLog(@"Failed to link program: %d", self.programId);
        if (self.programId) {
            glDeleteProgram(self.programId);
            self.programId = 0;
        }
        return NO;
    }
    
    for (ZLShaderUniform *uniform in [self.uniforms allValues]) {
        uniform.uniformId = glGetUniformLocation(self.programId, [uniform.uniformName UTF8String]);
    }
    
    return YES;
}

#pragma mark - shader load

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar* source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    if (status != GL_TRUE) {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            if (type == GL_VERTEX_SHADER) {
                self.vShaderLog = [NSString stringWithFormat:@"%s", log];
            } else {
                self.fShaderLog = [NSString stringWithFormat:@"%s", log];
            }
            free(log);
        }
    }
    return status == GL_TRUE;
}

- (BOOL)linkProgram {
    GLint status;
    glLinkProgram(self.programId);
    
    GLint logLength;
    glGetProgramiv(self.programId, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(self.programId, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }

    glGetProgramiv(self.programId, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

- (void)useProgrm {
    glUseProgram(self.programId);
}

- (void)dealloc {
    if (self.programId) {
        glDeleteProgram(self.programId);
        self.programId = 0;
    }
}

@end
