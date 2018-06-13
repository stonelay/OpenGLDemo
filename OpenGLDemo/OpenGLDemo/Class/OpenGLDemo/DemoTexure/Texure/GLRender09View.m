//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender09View.h"
#import "GLESMath.h"

#import "ZLGLProgram.h"

#import "GLLoadTool.h"



@interface GLRender09View() {
    GLuint VAO[2];
    
    CGPoint begin;
    
    CGFloat exRotate;
    CGFloat eyRotate;
    
    CGFloat xRotate;
    CGFloat yRotate;
    
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint texureBuffer;
}


@end

@implementation GLRender09View

- (instancetype)init {
    if (self = [super init]) {
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
    self.program.vShaderFile = @"shaderTexure08v";
    self.program.fShaderFile = @"shaderTexure08f";
    
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
    
    glGenTextures(1, &texureBuffer);
}

#pragma mark - data
- (void)setupData {
    
    CGFloat mLength = 0.3f;
    CGFloat nLength = 0.2f;
    
    GLfloat vAttrArr[][3] = {
        {-1,  -1, -1},
        {-1,  -1,  1},
        {-1,   1, -1},
        {-1,   1,  1},
        
        { 1,  -1, -1},
        { 1,  -1,  1},
        { 1,   1, -1},
        { 1,   1,  1},
    };
    
    GLfloat tAttrArr[][2] = {
        {0.0, 0.0},
        {0.0, 1.0},
        {1.0, 1.0},
        {1.0, 0.0},
    };
    
    GLuint mIndices[][4] = {
        {0, 1, 3, 2},
        {4, 6, 7, 5},
        {2, 3, 7, 6},
        {0, 4, 5, 1},
        {0, 2, 6, 4},
        {1, 5, 7, 3},
    };
    GLuint tIndices[] = {
        0,1,2,3
    };
    
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
        
//        GLuint position0 = glGetAttribLocation(self.myProgram, "position");
//        [self.program addAttribute:@"position"];
//        glBindAttribLocation(self.myProgram, 0, "position");
        glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
        glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
        
//        GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
        glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
        glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    }
    
//    GLuint projectionMatrixSlot = glGetUniformLocation(self.myProgram, "projectionMatrix");
//    GLuint modelViewMatrixSlot = glGetUniformLocation(self.myProgram, "modelViewMatrix");
    
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
    ksRotate(&_rotationMatrix, exRotate - xRotate, 1.0, 0.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, eyRotate - yRotate, 0.0, 1.0, 0.0); //绕Y轴
    
    // 矩阵相乘， 先平移，再旋转
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
//    GLuint texture = [self setupTexture:@"for_test01"];
    [GLLoadTool setupTexture:@"for_test01" buffer:texureBuffer texure:GL_TEXTURE0];
    
//    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];       // data
    
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
    
    [self presentRenderbuffer];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    if (allTouches.count == 1) {
        UITouch *touch = [allTouches anyObject];
        begin = [touch locationInView:self];
    }
    //    else if(allTouches.count == 2){
    //        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
    //        UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
    //
    //        CGPoint point1 = [touch1 locationInView:self.view];
    //        CGPoint point2 = [touch2 locationInView:self.view];
    //
    //        float x = point1.x - point2.x;
    //        float y = point1.y - point2.y;
    //
    //        _lastPinchDistance = sqrtf(x*x+y*y);
    //    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    //    if (allTouches.count == 1) {
    
    UITouch *touch = [allTouches anyObject];
    CGPoint current = [touch locationInView:self];
    //        NSArray* arr = [[touches anyObject] locations];
    //        [self.view convertPoint:currentPostion fromView:self.view];
    xRotate = begin.x - current.x;
    yRotate = begin.y - current.y;
    NSLog(@"%f", xRotate);
    NSLog(@"%f", yRotate);
    [self render];
    //    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    exRotate -= xRotate;
    eyRotate -= yRotate;
}

@end

