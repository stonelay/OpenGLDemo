//
//  GLRender05View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender05View.h"


static GLfloat attrArr[] = {
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    -0.5f, -0.5f, -1.0f,    0.0f, 0.0f, // 左下
    
    0.5f, 0.5f, -1.0f,      1.0f, 1.0f, // 右上
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
};

@interface GLRender05View() {
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint textureBuffer[2];
}

@end

@implementation GLRender05View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
        [self setupData]; // data
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexture05v";
    self.program.fShaderFile = @"shaderTexture05f";
    
    // attribute
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoor"];
    
    // uniform
    [self.program addUniform:@"colorMap0"];
    [self.program addUniform:@"colorMap1"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"textureCoor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    uniforms[UNIFORM_COLOR_MAP_1] = [self.program uniformID:@"colorMap1"];
    [self.program useProgrm];
}

#pragma mark - data
- (void)setupData {
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);

//    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);

//    GLuint textureCoor = glGetAttribLocation(self.myProgram, "textureCoor");
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    glGenTextures(2, textureBuffer);
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer[0] fileName:@"for_test01"];
    [self setupTexture:GL_TEXTURE1 buffer:textureBuffer[1] fileName:@"for_test02"];
    
//    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
//    GLuint buffer1 = glGetUniformLocation(self.myProgram, "colorMap1");
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_1], 1);
}

#pragma mark - render

- (void)updateData {}
- (void)draw {
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end


