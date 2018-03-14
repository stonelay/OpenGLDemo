//
//  GLRender04View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender04View.h"
#import "GLLoadTool.h"

@interface GLRender04View() {
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint textBuffer;
}

@end

@implementation GLRender04View

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
    
    self.program.vShaderFile = @"shaderTexure04v";
    self.program.fShaderFile = @"shaderTexure04f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"texureCoor"];
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"texureCoor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    [self.program useProgrm];
    
    glGenTextures(1, &textBuffer);
}

#pragma mark - data
- (void)setupData {
    [self drawPic];
    [self drawLine];
}

- (void)drawLine {
    GLfloat attrArr[] = {
        -0.8f, 0.0f, -0.5f,
        0.8f, 0.0f, -0.5f,
    };
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    //    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glDrawArrays(GL_LINES, 0, 2);
}

- (void)drawPic {
    GLfloat attrArr[] = {
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
        -0.5f, -0.5f, -1.0f,    0.0f, 0.0f, // 左下
        0.5f, 0.5f, -1.0f,      1.0f, 1.0f, // 右上
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
        
        //        0.5f, -0.5f, -1.0f, 1.0f, 1.0f,
        //        -0.5f, 0.5f, -1.0f, 0.0f, 0.0f,
        //        -0.5f, -0.5f, -1.0f, 0.0f, 1.0f,
        //        0.5f, 0.5f, -1.0f, 1.0f, 0.0f,
        //        -0.5f, 0.5f, -1.0f, 0.0f, 0.0f,
        //        0.5f, -0.5f, -1.0f, 1.0f, 1.0f,
    };
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    //    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    //    glVertexPointer(3, GL_FLOAT, 0,(void *)NULL);
    
    //    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    //    GLuint texture = [self setupTexture:@"for_test02"];
    //    [GLLoadTool setupTexture:@"for_test02" texure:GL_TEXTURE0];
    [GLLoadTool setupTexture:@"for_test02" buffer:textBuffer texure:GL_TEXTURE0];
    
    
    //    GLuint buffer0 = glGetUniformLocation(self.program.programId, "colorMap0");
    //    glUniform1i(buffer0, 0);
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];
    
    
//    glDrawArrays(GL_POINTS, 0, 6);
    
    [self presentRenderbuffer];
}


@end
