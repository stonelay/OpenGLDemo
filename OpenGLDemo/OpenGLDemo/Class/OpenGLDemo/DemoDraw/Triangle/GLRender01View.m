//
//  GLRender01View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender01View.h"
#import "ZLGLProgram.h"

static GLfloat attrArr[] = {
    0.5f,  -0.5f, -1.0f,
    0.0f, 0.5f,  -1.0f,
    -0.5f, -0.5f, -1.0f
};

@interface GLRender01View() {
    GLint attributes[NUM_ATTRIBUTES];
}

@property (nonatomic, strong) ZLGLProgram *program;

@end

@implementation GLRender01View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContext];    // gl context
        [self setupGLProgram];  // shader
        [self setupData];       // data
    }
    return self;
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        return;
    }
    
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set OpenGLES 2.0 context");
        return;
    }
    self.context = context;
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
    [self.program addAttribute:@"position"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    [self.program useProgrm];
}

#pragma mark - data
- (void)setupData {
    
//    GLuint attrBuffer;
//    glGenBuffers(1, &attrBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
//    GLuint position0 = glGetAttribLocation(self.programId, "position");
//    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
//    [self.program useProgrm];
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, 0, attrArr);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
}

#pragma mark - render

- (void)render {
    
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    [self.program useProgrm];
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [self presentRenderbuffer];
}


@end
