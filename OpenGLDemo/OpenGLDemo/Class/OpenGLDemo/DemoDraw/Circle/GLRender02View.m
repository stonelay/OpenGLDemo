//
//  GLRender02View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender02View.h"
#import <OpenGLES/ES2/glext.h>

#define VERTEXCOUNT  50
@interface GLRender02View()

@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;

@end

@implementation GLRender02View

- (instancetype)init {
    if (self = [super init]) {
        [self setupGLProgram];  // shader
        [self setupData];       // data
    }
    return self;
}

- (void)layoutSubviews {
    
    [self destoryRenderAndFrameBuffer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.myProgram = [self setupProgaramVFile:@"shaderDrawv" fFile:@"shaderDrawf"];
}

#pragma mark - data
- (void)setupData {
//    GLfloat attrArr[] = {
//        0.5f,  -0.5f, -1.0f,
//        0.0f, 0.5f,  -1.0f,
//        -0.5f, -0.5f, -1.0f
//    };
    int count = VERTEXCOUNT;

    GLfloat attrArr[VERTEXCOUNT * 3];
    
//    Vertex *vertext = (Vertex *)malloc(sizeof(Vertex) * _vertCount);
//    memset(vertext, 0x00, sizeof(Vertex) * _vertCount);
    
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
        
        printf("%f , %f\n", x, y);
    }
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
    glEnableVertexAttribArray(position0);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, VERTEXCOUNT);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - buffer

- (void)setupRenderBuffer {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    // 为 颜色缓冲区 分配存储空间
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}

- (void)setupFrameBuffer {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, self.myColorRenderBuffer);
}

- (void)destoryRenderAndFrameBuffer {
    glDeleteFramebuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;
}



@end
