//
//  GLRender02View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender02View.h"
#import <OpenGLES/ES2/glext.h>
#import "ZLGLProgram.h"

#define VERTEXCOUNT  50
@interface GLRender02View() {
    GLint attributes[NUM_ATTRIBUTES];
    
    GLfloat attrArr[VERTEXCOUNT * 3];
}

@end

@implementation GLRender02View

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
    
    self.program.vShaderFile = @"shaderDrawv";
    self.program.fShaderFile = @"shaderDrawf";
    
    // attribute
    [self.program addAttribute:@"position"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    [self.program useProgrm];
}

#pragma mark - data
- (void)setupData {
    int count = VERTEXCOUNT;
    
    float a = 0.8; // 水平方向的半径
    float b = a * SCREENWIDTH / SCREENHEIGHT;
    
    float delta = 2.0*M_PI/count;
    for (int i = 0; i < count; i++) {
        GLfloat x = a * cos(delta * i);
        GLfloat y = b * sin(delta * i);
        GLfloat z = 0.0;
        attrArr[i * 3 + 0] = x;
        attrArr[i * 3 + 1] = y;
        attrArr[i * 3 + 2] = z;
        
//        printf("%f , %f\n", x, y);
    }
    
    // 使用 VBO, 顶点数据在服务端 传偏移量 提高效率
//    GLuint attrBuffer;
//    glGenBuffers(1, &attrBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
//
////    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
//    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    // 不使用 VBO, 定点数据在 客户端
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, 0, attrArr);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self setupData];       // data
    
    [self.program useProgrm];
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, VERTEXCOUNT);
    
    [self presentRenderbuffer];
}


@end
