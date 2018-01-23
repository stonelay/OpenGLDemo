//
//  GLRender04View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender04View.h"

@interface GLRender04View()

@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;

@end

@implementation GLRender04View

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
    self.myProgram = [self setupProgaramVFile:@"shaderTexure04v" fFile:@"shaderTexure04f"];
}

#pragma mark - data
- (void)setupData {
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
    
    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(position0);
    
    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
    glVertexAttribPointer(texureCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(texureCoor);
    
    GLuint texture = [self setupTexture:@"for_test02"];
    
    

    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(buffer0, 0);
    
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
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


- (GLuint)setupTexture:(NSString *)fileName {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    glActiveTexture(GL_TEXTURE0);

    GLuint buffer1;
    glGenTextures(1, &buffer1);
    glBindTexture(GL_TEXTURE_2D, buffer1);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
    return buffer1;
}
@end
