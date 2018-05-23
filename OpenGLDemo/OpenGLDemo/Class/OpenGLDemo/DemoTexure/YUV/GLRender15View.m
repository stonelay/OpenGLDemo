//
//  GLRender15View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender15View.h"
#import "GLLoadTool.h"

@interface GLRender15View() {
    
    GLint uniforms[NUM_UNIFORMS];
    GLint attributes[NUM_ATTRIBUTES];
    
    GLuint id_y, id_u, id_v; // Texture id
}

@end

@implementation GLRender15View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupFramebuffer];
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexure15v";
    self.program.fShaderFile = @"shaderTexure15f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"TexCoordIn"];
    [self.program addUniform:@"SamplerY"];
    [self.program addUniform:@"SamplerU"];
    [self.program addUniform:@"SamplerV"];
    [self.program compileAndLink];
    uniforms[UNIFORM_COLOR_Y] = [self.program uniformID:@"SamplerY"];
    uniforms[UNIFORM_COLOR_U] = [self.program uniformID:@"SamplerU"];
    uniforms[UNIFORM_COLOR_V] = [self.program uniformID:@"SamplerV"];
    attributes[ATTRIBUTE_POSITION] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"TexCoordIn"];
    [self.program useProgrm];
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &id_y);
    glBindTexture(GL_TEXTURE_2D, id_y);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE1);
    glGenTextures(1, &id_u);
    glBindTexture(GL_TEXTURE_2D, id_u);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE2);
    glGenTextures(1, &id_v);
    glBindTexture(GL_TEXTURE_2D, id_v);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

#pragma mark - data
- (void)setupData {
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat coordVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
    
    glVertexAttribPointer(attributes[ATTRIBUTE_POSITION], 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_POSITION]);
    //    glVertexPointer(3, GL_FLOAT, 0,(void *)NULL);
    
    //    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 2, GL_FLOAT, 0, 0, coordVertices);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    // Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [self presentRenderbuffer];
}


#pragma mark - 接口
static BOOL isGray = YES;
- (void)displayYUV420pData:(void *)data width:(GLsizei)w height:(GLsizei)h {
    
    isGray = !isGray;
    unsigned char *blackData=(unsigned char *)malloc(w*h*3/2);
    memcpy(blackData, data, w*h*3/2);
    if (isGray) {
        memset(blackData+w*h,128,w*h/2);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, id_y);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, w, h, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);
    glUniform1i(uniforms[UNIFORM_COLOR_Y], 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, id_u);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, w/2, h/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + w * h);
    glUniform1i(uniforms[UNIFORM_COLOR_U], 1);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, id_v);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, w/2, h/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + w * h * 5 / 4);
    glUniform1i(uniforms[UNIFORM_COLOR_V], 2);
    [self render];
}

@end