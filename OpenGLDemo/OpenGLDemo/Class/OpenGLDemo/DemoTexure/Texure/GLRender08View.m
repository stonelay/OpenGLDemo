//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender08View.h"
#import "GLESMath.h"

static CGFloat mLength = 0.3f;
static CGFloat nLength = 0.2f;

static GLfloat vAttrArr[][3] = {
    {-1,  -1, -1},
    {-1,  -1,  1},
    {-1,   1, -1},
    {-1,   1,  1},
    
    { 1,  -1, -1},
    { 1,  -1,  1},
    { 1,   1, -1},
    { 1,   1,  1},
};

static GLfloat tAttrArr[][2] = {
    {0.0, 0.0},
    {0.0, 1.0},
    {1.0, 1.0},
    {1.0, 0.0},
};

static GLuint mIndices[][4] = {
    {0, 1, 3, 2},
    {4, 6, 7, 5},
    {2, 3, 7, 6},
    {0, 4, 5, 1},
    {0, 2, 6, 4},
    {1, 5, 7, 3},
};
static GLuint tIndices[] = {
    0,1,2,3
};



@interface GLRender08View() {
    GLuint VAO[2];
}

@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myDepthRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;

@property (nonatomic, strong) UISlider *xSlider;
@property (nonatomic, strong) UISlider *ySlider;

@end

@implementation GLRender08View

- (instancetype)init {
    if (self = [super init]) {
        [self setupGLProgram];  // shader
        [self setupData];
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
    
    [self setupFrameBuffer];
    
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.myProgram = [self setupProgaramVFile:@"shaderTexure08v" fFile:@"shaderTexure08f"];
}

#pragma mark - data

- (void)setupData {
    
    GLfloat bAttrArr[6][4][5];
    for (int i = 0; i < sizeof(mIndices)/sizeof(mIndices[0]); i++) {
        for (int j = 0; j < sizeof(mIndices[i])/sizeof(GLfloat); j++) {
            for (int k = 0; k < 3; k++) {
                bAttrArr[i][j][k] = vAttrArr[mIndices[i][j]][k] * mLength;
            }
            for (int m = 0; m < sizeof(tAttrArr[i])/sizeof(GLfloat); m++) {
                bAttrArr[i][j][3 + m] = tAttrArr[tIndices[j]][m];
            }
        }
    }
    
    GLfloat cAttrArr[6][4][5];
    for (int i = 0; i < sizeof(mIndices)/sizeof(mIndices[0]); i++) {
        for (int j = 0; j < sizeof(mIndices[i])/sizeof(GLfloat); j++) {
            for (int k = 0; k < 3; k++) {
                if (k == 0) {
                    cAttrArr[i][j][k] = vAttrArr[mIndices[i][j]][k] * nLength + 0.8;
                } else {
                    cAttrArr[i][j][k] = vAttrArr[mIndices[i][j]][k] * nLength;
                }
            }
            for (int m = 0; m < sizeof(tAttrArr[i])/sizeof(GLfloat); m++) {
                cAttrArr[i][j][3 + m] = tAttrArr[tIndices[j]][m];
            }
        }
    }
    
    
    glGenVertexArraysOES(2, VAO);
    for (int i = 0; i < 2; i ++) {
        glBindVertexArrayOES(VAO[i]);
        
        GLuint buf;
        glGenBuffers(1, &buf);
        glBindBuffer(GL_ARRAY_BUFFER, buf);
        if (i == 0) {
            glBufferData(GL_ARRAY_BUFFER, sizeof(bAttrArr), bAttrArr, GL_STATIC_DRAW);
        } else {
            glBufferData(GL_ARRAY_BUFFER, sizeof(cAttrArr), cAttrArr, GL_STATIC_DRAW);
        }
        
        GLuint position0 = glGetAttribLocation(self.myProgram, "position");
        glVertexAttribPointer(position0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
        glEnableVertexAttribArray(position0);
        
        GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
        glVertexAttribPointer(texureCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
        glEnableVertexAttribArray(texureCoor);
    }
    
    GLuint texture = [self setupTexture:@"for_test01"];
}

- (void)updateData {
    
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
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -10.0f);
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
    
    
    
    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(buffer0, 0);
}


#pragma mark - render

- (void)render {
    
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    glBindRenderbuffer(GL_RENDERBUFFER, _myColorRenderBuffer);
    glClearColor(0, 1.0, 0, 1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glUseProgram(self.myProgram);
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    [self updateData];       // data
    
    GLuint mIndices[6][4] = {
        {0,  1, 2, 3},
        {4,  5, 6, 7},
        {8,  9,10,11},
        {12,13,14,15},
        {16,17,18,19},
        {20,21,22,23},
    };
    for (int i = 0; i < 2; i++) {
        glBindVertexArrayOES(VAO[i]);
        for (int i = 0; i < 6; i++) {
            glDrawElements(GL_TRIANGLE_FAN, sizeof(mIndices[i]) / sizeof(mIndices[i][0]), GL_UNSIGNED_INT, mIndices[i]);
        }
    }
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - buffer

- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &_myColorFrameBuffer); // 创建帧缓冲区
    glGenRenderbuffers(1, &_myColorRenderBuffer);   // 创建绘制缓冲区
    glBindFramebuffer(GL_FRAMEBUFFER, _myColorFrameBuffer); // 绑定帧缓冲区到渲染管线
    glBindRenderbuffer(GL_RENDERBUFFER, _myColorRenderBuffer);  // 绑定绘制缓冲区到渲染管线
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _myColorRenderBuffer); // 绑定绘制缓冲区到帧缓冲区
    
    GLint width;
    GLint height;
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];   // 为绘制缓冲区分配存储区，此处将CAEAGLLayer的绘制存储区作为绘制缓冲区的存储区
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);    // 获取绘制缓冲区的像素宽度
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);  // 获取绘制缓冲区的像素高度
    
    glGenRenderbuffers(1, &_myDepthRenderBuffer);    // 创建深度缓冲区
    glBindRenderbuffer(GL_RENDERBUFFER, _myDepthRenderBuffer);   // 绑定深度缓冲区到渲染管线
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);    // 为深度缓冲区分配存储区
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _myDepthRenderBuffer);
}

- (void)destoryRenderAndFrameBuffer {
    glDeleteFramebuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;
    glDeleteRenderbuffers(1, &_myDepthRenderBuffer);
    self.myDepthRenderBuffer = 0;
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
