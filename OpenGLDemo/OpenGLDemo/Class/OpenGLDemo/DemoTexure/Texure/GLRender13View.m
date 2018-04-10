//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender13View.h"
#import "GLESMath.h"

#import "GLLoadTool.h"

#import "ZLGLProgram.h"


@interface GLRender13View() {
    //    GLuint VAO[2];
    //    GLuint VBO[2];
    
    GLuint earthVBO;
    GLuint earthBuffer;
    GLuint picVBO;
    GLuint picBuffer;
    
    CGPoint begin;
    
    CGFloat exRotate;
    CGFloat eyRotate;
    
    CGFloat xRotate;
    CGFloat yRotate;
    
    GLint e_attributes[NUM_ATTRIBUTES];
    GLint e_uniforms[NUM_UNIFORMS];
    
    GLint p_attributes[NUM_ATTRIBUTES];
    GLint p_uniforms[NUM_UNIFORMS];
    
    BOOL isPoint;
}

@property (nonatomic, strong) ZLGLProgram *earthProgram;
@property (nonatomic, strong) ZLGLProgram *picPorgram;

@end

@implementation GLRender13View

- (instancetype)init {
    if (self = [super init]) {
        [self setupGLProgram];  // shader
        [self initComponent];
        
    }
    return self;
}

- (void)initComponent {
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(10, 64 + 10, 80, 30)];
    [button setTitle:@"change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chenge:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%f %f", self.width, self.height);
    [self setupFramebuffer];
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    [self initEarthProgram];
    [self initPicProgram];
    [self initVBO];
}

- (void)initEarthProgram {
    //加载shader
    self.earthProgram = [[ZLGLProgram alloc] init];
    self.earthProgram.vShaderFile = @"shaderTexure12v";
    self.earthProgram.fShaderFile = @"shaderTexure12f";
    
    [self.earthProgram addAttribute:@"position"];
    [self.earthProgram addAttribute:@"texureCoor"];
    [self.earthProgram addUniform:@"projectionMatrix"];
    [self.earthProgram addUniform:@"modelViewMatrix"];
    [self.earthProgram addUniform:@"colorMap0"];
    
    [self.earthProgram compileAndLink];
    
    e_attributes[ATTRIBUTE_VERTEX] = [self.earthProgram attributeID:@"position"];
    e_attributes[ATTRIBUTE_TEXTURE_COORD] = [self.earthProgram attributeID:@"texureCoor"];
    e_uniforms[UNIFORM_PROJECTION_MATRIX] = [self.earthProgram uniformID:@"projectionMatrix"];
    e_uniforms[UNIFORM_MODEL_MATRIX] = [self.earthProgram uniformID:@"modelViewMatrix"];
    e_uniforms[UNIFORM_COLOR_MAP_0] = [self.earthProgram uniformID:@"colorMap0"];
    
}

- (void)initPicProgram {
    //加载shader
    self.picPorgram = [[ZLGLProgram alloc] init];
    self.picPorgram.vShaderFile = @"shaderTexureLinev";
    self.picPorgram.fShaderFile = @"shaderTexureLinef";
    
    [self.picPorgram addAttribute:@"position"];
//    [self.picPorgram addAttribute:@"texureCoor"];
    [self.picPorgram addUniform:@"projectionMatrix"];
    [self.picPorgram addUniform:@"modelViewMatrix"];
    [self.picPorgram addUniform:@"colorMap0"];
    
    [self.picPorgram compileAndLink];
    
    p_attributes[ATTRIBUTE_VERTEX] = [self.picPorgram attributeID:@"position"];
//    p_attributes[ATTRIBUTE_TEXTURE_COORD] = [self.picPorgram attributeID:@"texureCoor"];
    p_uniforms[UNIFORM_PROJECTION_MATRIX] = [self.picPorgram uniformID:@"projectionMatrix"];
    p_uniforms[UNIFORM_MODEL_MATRIX] = [self.picPorgram uniformID:@"modelViewMatrix"];
    p_uniforms[UNIFORM_COLOR_MAP_0] = [self.picPorgram uniformID:@"colorMap0"];
}

- (void)initVBO {
    glGenBuffers(1, &earthVBO);
    glGenBuffers(1, &picVBO);
    glGenTextures(1, &earthBuffer);
    glGenTextures(1, &picBuffer);
}

#pragma mark - data
- (void)setupData {
    [self drawEarth];
    [self drawLine];
}

- (void)drawLine {
    glUseProgram(self.picPorgram.programId);
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
            
            pointArray[i][j][3] = (float)j / slice;
            pointArray[i][j][4] = (float)i / statck;
        }
    }
    
    CGFloat mRadius = 1.2;
    GLfloat mPointArray[statck+1][slice+1][5];
    for (int i = 0; i <= statck; i++) {
        float alpha0 = (float) (i * statckStep);
        
        float y = (float) (mRadius * cos(alpha0));
        float r = (float) (mRadius * sin(alpha0));
        //        NSLog(@"%f", y);
        for (int j = 0; j <= slice; j++) {
            float alpha1 = (float) (- M_PI + (j * sliceStep));
            
            float x = r * cos(alpha1);
            float z = r * sin(alpha1);
            
            mPointArray[i][j][0] = x;
            mPointArray[i][j][1] = y;
            mPointArray[i][j][2] = z;
            
            mPointArray[i][j][3] = (float)j / slice;
            mPointArray[i][j][4] = (float)i / statck;
        }
    }
    
    GLfloat drawArray[statck+1][slice+1][2][5];
    for (int i = 0; i <= statck; i++) {
        for (int j = 0; j <= slice; j++) {
            drawArray[i][j][0][0] = mPointArray[i][j][0];
            drawArray[i][j][0][1] = mPointArray[i][j][1];
            drawArray[i][j][0][2] = mPointArray[i][j][2];
            drawArray[i][j][0][3] = mPointArray[i][j][3];
            drawArray[i][j][0][4] = mPointArray[i][j][4];
            
            drawArray[i][j][1][0] = pointArray[i][j][0];
            drawArray[i][j][1][1] = pointArray[i][j][1];
            drawArray[i][j][1][2] = pointArray[i][j][2];
            drawArray[i][j][1][3] = pointArray[i][j][3];
            drawArray[i][j][1][4] = pointArray[i][j][4];
        }
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, picVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(drawArray), drawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(p_attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(p_attributes[ATTRIBUTE_VERTEX]);
    
//    glVertexAttribPointer(e_attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
//    glEnableVertexAttribArray(e_attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    // 透视投影
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 100.0); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(p_uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    
    // 需要计算 正反面
    glEnable(GL_CULL_FACE);
    
    //平移
    // 1. 平移 至 能看到的
    KSMatrix4 _modelViewMatrix;
    ksMatrixLoadIdentity(&_modelViewMatrix);
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -10.0f);
    
    //旋转
    // 2. 绕x,y轴 旋转
    KSMatrix4 _rotationMatrix;
    ksMatrixLoadIdentity(&_rotationMatrix);
    ksRotate(&_rotationMatrix, xRotate - exRotate, 0.0, 1.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, yRotate - eyRotate, 1.0, 0.0, 0.0); //绕Y轴
    
    // 矩阵相乘， 先平移，再旋转
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(p_uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
    glDrawArrays(GL_LINES, 0,  ((statck+1) * 2) * (slice+1));
}

- (void)drawEarth {
    glUseProgram(self.earthProgram.programId);
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
            
            pointArray[i][j][3] = (float)j / slice;
            pointArray[i][j][4] = (float)i / statck;
        }
    }
    
    GLfloat drawArray[statck+1][slice+1][2][5];
    for (int i = 0; i < statck; i++) {
        for (int j = 0; j <= slice; j++) {
            drawArray[i][j][0][0] = pointArray[i+1][j][0];
            drawArray[i][j][0][1] = pointArray[i+1][j][1];
            drawArray[i][j][0][2] = pointArray[i+1][j][2];
            drawArray[i][j][0][3] = pointArray[i+1][j][3];
            drawArray[i][j][0][4] = pointArray[i+1][j][4];
            
            drawArray[i][j][1][0] = pointArray[i][j][0];
            drawArray[i][j][1][1] = pointArray[i][j][1];
            drawArray[i][j][1][2] = pointArray[i][j][2];
            drawArray[i][j][1][3] = pointArray[i][j][3];
            drawArray[i][j][1][4] = pointArray[i][j][4];
        }
    }
    
    
    glBindBuffer(GL_ARRAY_BUFFER, earthVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(drawArray), drawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(e_attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(e_attributes[ATTRIBUTE_VERTEX]);
    
    glVertexAttribPointer(e_attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(e_attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    // 透视投影
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 100.0); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(e_uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    
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
    ksRotate(&_rotationMatrix, xRotate - exRotate, 0.0, 1.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, yRotate - eyRotate , 1.0, 0.0, 0.0); //绕Y轴
    
    // 矩阵相乘， 先平移，再旋转
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(e_uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
//    [GLLoadTool setupTexture:@"pic_earth" buffer:earthBuffer texure:GL_TEXTURE0];
    [self loadTexture:GL_TEXTURE0 fileName:@"pic_earth"];
    
    //    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(e_uniforms[UNIFORM_COLOR_MAP_0], 0);
    
    if (isPoint) {
        glDrawArrays(GL_POINTS, 0,  ((statck+1) * 2 - 2) * (slice+1));
    } else {
        glDrawArrays(GL_TRIANGLE_STRIP, 0, ((statck+1) * 2 - 2) * (slice+1));
    }
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    [self.program useProgrm];
    
    [self setupData];       // data
    
    [self presentRenderbuffer];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    if (allTouches.count == 1) {
        UITouch *touch = [allTouches anyObject];
        begin = [touch locationInView:self];
        xRotate = 0;
        yRotate = 0;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    
    UITouch *touch = [allTouches anyObject];
    CGPoint current = [touch locationInView:self];
    
    xRotate = begin.x - current.x;
    yRotate = begin.y - current.y;
    NSLog(@"%f %f", xRotate, yRotate);
    
    [self render];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    exRotate -= xRotate;
    eyRotate -= yRotate;
}

- (void)chenge:(id)sender {
    isPoint = !isPoint;
    xRotate = 0;
    yRotate = 0;
    [self render];
}

@end



