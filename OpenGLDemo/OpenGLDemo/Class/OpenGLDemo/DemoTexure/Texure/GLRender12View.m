//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender12View.h"
#import "GLESMath.h"

#import "GLLoadTool.h"

#import "ZLGLProgram.h"


@interface GLRender12View() {
//    GLuint VAO[2];
//    GLuint VBO[2];

    GLuint vbo;
    GLuint textureBuffer;
    
    CGPoint begin;
    
    CGFloat exRotate;
    CGFloat eyRotate;
    
    CGFloat xRotate;
    CGFloat yRotate;
    
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
}


@end

@implementation GLRender12View

- (instancetype)init {
    if (self = [super init]) {
        [self setupContext];
        [self setupGLProgram];  // shader
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
    self.program.vShaderFile = @"shaderTexure12v";
    self.program.fShaderFile = @"shaderTexure12f";
    
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"texureCoor"];
    [self.program addUniform:@"projectionMatrix"];
    [self.program addUniform:@"modelViewMatrix"];
    [self.program addUniform:@"colorMap0"];
    
    [self.program compileAndLink];
    
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"texureCoor"];
    uniforms[UNIFORM_PROJECTION_MATRIX] = [self.program uniformID:@"projectionMatrix"];
    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"modelViewMatrix"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    
    [self initVBO];
}

- (void)initVBO {
//    glGenVertexArraysOES(2, VAO);
    glGenBuffers(1, &vbo);
    glGenTextures(1, &textureBuffer);
}

#pragma mark - data
- (void)setupData {
    
    float radius = 1.0f;     //球的半径
    int statck = 20;         //statck：切片----把球体横向切成几部分
    int slice = 50;//纵向切几部分
    float statckStep = (float) (M_PI / statck);//单位角度值
    
    float sliceStep = (float) (M_PI * 2 / slice);//水平圆递增的角度
    
    GLfloat pointArray[statck+1][slice+1][5];
    for (int i = 0; i <= statck; i++) {
        float alpha0 = (float) (i * statckStep);

        float y = (float) (radius * cos(alpha0));
        float r = (float) (radius * sin(alpha0));
//        NSLog(@"%f", y);
        for (int j = 0; j <= slice; j++) {
            float alpha1 = (float) (- M_PI + (j * sliceStep));
            
            float x = r * cos(alpha1);
            float z = r * sin(alpha1);
            
            pointArray[i][j][0] = x;
            pointArray[i][j][1] = y;
            pointArray[i][j][2] = z;
            
            pointArray[i][j][3] = 1.0 / slice * j;
            pointArray[i][j][4] = 1.0 / statck * i;
//            NSLog(@"===%f, %f", pointArray[i][j][3], pointArray[i][j][4]);
        }
    }
    
    GLfloat drawArray[statck+1][slice+1][2][5];
    for (int i = 0; i < statck; i++) {
        for (int j = 0; j <= slice; j++) {
            drawArray[i][j][0][0] = pointArray[i][j][0];
            drawArray[i][j][0][1] = pointArray[i][j][1];
            drawArray[i][j][0][2] = pointArray[i][j][2];
            drawArray[i][j][0][3] = pointArray[i][j][3];
            drawArray[i][j][0][4] = pointArray[i][j][4];
            
            drawArray[i][j][1][0] = pointArray[i+1][j][0];
            drawArray[i][j][1][1] = pointArray[i+1][j][1];
            drawArray[i][j][1][2] = pointArray[i+1][j][2];
            drawArray[i][j][1][3] = pointArray[i+1][j][3];
            drawArray[i][j][1][4] = pointArray[i+1][j][4];
        }
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(drawArray), drawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    // 透视投影
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 100.0); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    
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
    ksRotate(&_rotationMatrix, exRotate - xRotate, 0.0, 1.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, eyRotate - yRotate, 1.0, 0.0, 0.0); //绕Y轴
    
    // 矩阵相乘， 先平移，再旋转
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
//    GLuint texture = [self setupTexture:@"for_test01"];
//    [GLLoadTool setupTexture:@"pic_earth" texure:GL_TEXTURE0];
    [GLLoadTool setupTexture:@"pic_earth" buffer:textureBuffer texure:GL_TEXTURE0];
    
    //    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, ((statck+1) * 2 - 2) * (slice+1));
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    
    [self setupData];       // data
    
    
    [self presentRenderbuffer];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    if (allTouches.count == 1) {
        UITouch *touch = [allTouches anyObject];
        begin = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    
    UITouch *touch = [allTouches anyObject];
    CGPoint current = [touch locationInView:self];
    
    xRotate = begin.x - current.x;
    yRotate = begin.y - current.y;
    
    [self render];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    exRotate -= xRotate;
    eyRotate -= yRotate;
}

@end


