//
//  GLRender15View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender15View.h"

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
        [self setupData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self setupFramebuffer];
//    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexture15v";
    self.program.fShaderFile = @"shaderTexture15f";
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
    static const GLfloat attrArray[] = {
        -1.0f, 0.5, 0.0f, 1.0f,
        -0.5, -1.0f, 1.0f, 1.0f,
        0.5,  1.0f, 0.0f, 0.0f,
        1.0f, -0.5, 1.0f, 0.0f,
    };
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArray), attrArray, GL_DYNAMIC_DRAW);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_POSITION], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_POSITION]);

    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4, NULL+sizeof(GL_FLOAT)*2);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
}

#pragma mark - render
- (void)updateData {
    
}

- (void)draw {
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - 接口
static BOOL isGray = YES;
- (void)displayYUV420pData:(void *)data width:(GLsizei)w height:(GLsizei)h {
    
    isGray = !isGray;
    unsigned char *blackData=(unsigned char *)malloc(w*h*3/2);
    
    //---1.5*w*h---//
    //--Y--/-U-/-V-//
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
