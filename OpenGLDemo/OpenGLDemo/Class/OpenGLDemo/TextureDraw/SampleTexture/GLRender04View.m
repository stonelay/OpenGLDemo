//
//  GLRender04View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender04View.h"


static GLfloat lineAttrArr[] = {
    -0.8f, 0.0f, -0.5f,
    0.8f, 0.0f, -0.5f,
};

static GLfloat picAttrArr[] = {
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    -0.5f, -0.5f, -1.0f,    0.0f, 0.0f, // 左下
    0.5f, 0.5f, -1.0f,      1.0f, 1.0f, // 右上
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
};

@interface GLRender04View() {
    GLuint VAO[2];
    
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint textureBuffer;
}

@end

@implementation GLRender04View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
        [self setupData];
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
    
    self.program.vShaderFile = @"shaderTexture04v";
    self.program.fShaderFile = @"shaderTexture04f";
    
    // attribute
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoor"];
    // uniform
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"textureCoor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    [self.program useProgrm];
}

#pragma mark - data
- (void)setupData {
    glGenVertexArraysOES(2, VAO);
    
    // line
    glBindVertexArrayOES(VAO[0]);
    GLuint lineAttrBuffer;
    glGenBuffers(1, &lineAttrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, lineAttrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(lineAttrArr), lineAttrArr, GL_DYNAMIC_DRAW);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glBindVertexArrayOES(VAO[1]);
    GLuint picAttrBuffer;
    glGenBuffers(1, &picAttrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, picAttrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(picAttrArr), picAttrArr, GL_DYNAMIC_DRAW);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    glGenTextures(1, &textureBuffer);
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"for_test02"];
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
}

#pragma mark - render
- (void)updateData {}
- (void)draw {
    glBindVertexArrayOES(VAO[0]);
    glDrawArrays(GL_LINES, 0, 2);

    glBindVertexArrayOES(VAO[1]);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


@end
