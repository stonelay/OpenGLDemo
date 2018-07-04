//
//  GLRender07View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender07View.h"
#import "GLESMath.h"


@interface GLRender07View()

@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;

@property (nonatomic, strong) UISlider *xSlider;
@property (nonatomic, strong) UISlider *ySlider;

@end

@implementation GLRender07View

- (instancetype)init {
    if (self = [super init]) {
        [self setupGLProgram];  // shader
        
        [self addComponent];
    }
    return self;
}

- (void)addComponent {
    [self addSubview:self.xSlider];
    [self addSubview:self.ySlider];
}

- (UISlider *)xSlider {
    if (!_xSlider) {
        _xSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREENWIDTH/4, 100, SCREENWIDTH/2, 100 * SCALE)];
        
        _xSlider.minimumValue = 0;// 设置最小值
        _xSlider.maximumValue = 360;// 设置最大值
        _xSlider.value = 0;// 设置初始值
        _xSlider.continuous = YES;// 设置可连续变化
        [_xSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _xSlider;
}

- (UISlider *)ySlider {
    if (!_ySlider) {
        _ySlider = [[UISlider alloc] init];
        _ySlider.transform = CGAffineTransformMakeRotation(1.57079633);
        _ySlider.frame = CGRectMake(30, SCREENHEIGHT/4, 100 * SCALE ,SCREENHEIGHT/2);
        _ySlider.minimumValue = 0;// 设置最小值
        _ySlider.maximumValue = 360;// 设置最大值
        _ySlider.value = 0;// 设置初始值
        _ySlider.continuous = YES;// 设置可连续变化
        [_ySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _ySlider;
}

- (void)sliderValueChanged:(id)sender {
    [self render];
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
    self.myProgram = [self setupProgaramVFile:@"shaderTexure07v" fFile:@"shaderTexure07f"];
}

#pragma mark - data
- (void)setupData {
    
    
    
    GLfloat attrArr[] = {
        0.5f, -0.5f, 0.0f,     1.0f, 0.0f, // 右下
        -0.5f, 0.5f, 0.0f,     0.0f, 1.0f, // 左上
        -0.5f, -0.5f, 0.0f,    0.0f, 0.0f, // 左下
        0.5f, 0.5f, 0.0f,      1.0f, 1.0f, // 右上
        0.0f, 0.0f, 1.0f,      0.5, 0.5, // 中
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
    
    
    GLuint projectionMatrixSlot = glGetUniformLocation(self.myProgram, "projectionMatrix");
    GLuint modelViewMatrixSlot = glGetUniformLocation(self.myProgram, "modelViewMatrix");
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    // 透视投影
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 100.0); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    
    // 需要计算 正反面
    glEnable(GL_CULL_FACE);
    
    
    KSMatrix4 _modelViewMatrix;
    ksMatrixLoadIdentity(&_modelViewMatrix);
    
    //平移
    // 1. 平移 至 能看到的
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -20.0f);
    KSMatrix4 _rotationMatrix;
    ksMatrixLoadIdentity(&_rotationMatrix);
    
    //旋转
    // 2. 绕x,y轴 旋转
    ksRotate(&_rotationMatrix, self.ySlider.value, 1.0, 0.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, self.xSlider.value, 0.0, 1.0, 0.0); //绕Y轴
    
    // 矩阵相乘， 先平移，再旋转
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(modelViewMatrixSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
    GLuint texture = [self setupTexture:@"for_test01"];
    
    
    //    获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
//    GLuint rotate = glGetUniformLocation(self.myProgram, "rotateMatrix");
//    
//    float xRotate = self.xSlider.value;
//    float radians = xRotate * 3.14159f / 180.0f;
//    
//    float s = sin(radians);
//    float c = cos(radians);
//    
//    //z轴旋转矩阵
//    GLfloat zRotation[16] = { //
//        c, -s, 0, 0, //
//        s, c, 0, 0,//
//        0, 0, 1.0, 0,//
//        0.0, 0, 0, 1.0//
//    };
//    
//    //y轴 旋转矩阵
//    GLfloat yRotation[16] = { //
//        c, 0, s, 0, //
//        0, 1.0, 0, 0,//
//        -s, 0, c, 0,//
//        0.0, 0, 0, 1.0//
//    };
//    
//    GLfloat xRotation[16] = { //
//        1.0, 0, 0, 0, //
//        0, c, s, 0,//
//        0, -s, c, 0,//
//        0.0, 0, 0, 1.0//
//    };
//    
//    //设置旋转矩阵
//    glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&yRotation[0]);
    
    
    
    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(buffer0, 0);
    
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    [self setupData];       // data
    
//    glDrawArrays(GL_TRIANGLES, 0, 6);
    GLuint indices[] = {
//        0, 1, 2,
//        0, 3, 1,
//        4, 1, 2,
//        4, 3, 1,
//        4, 0, 3,
//        4, 2, 0,
//        4,1,4,2,4,0,4,3,4,
        4,0,3,1,2,0,
    };
    GLuint backIndices[] = {
        
        0,2,1,3
    };
    glDrawElements(GL_TRIANGLE_FAN, sizeof(indices) / sizeof(indices[0]), GL_UNSIGNED_INT, indices);
    glDrawElements(GL_TRIANGLE_FAN, sizeof(backIndices) / sizeof(backIndices[0]), GL_UNSIGNED_INT, backIndices);

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

