//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender13View.h"
#import "GLESMath.h"

#import "ZLGLProgram.h"

static int statck = 20;     //statck：切片----把球体横向切成几部分
static int slice = 50;      //纵向切几部分

@interface GLRender13View() {
    GLuint VAO[2];
    
    GLuint earthVBO;
    GLuint lineVBO;
    
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
    
    GLuint textureBuffer;
}

@property (nonatomic, strong) ZLGLProgram *earthProgram;
@property (nonatomic, strong) ZLGLProgram *linePorgram;

@end

@implementation GLRender13View

- (instancetype)init {
    if (self = [super init]) {
        [self setupGLProgram];  // shader
        [self initComponent];
        [self setupData];
    }
    return self;
}

- (void)initComponent {
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(10, 64 + 10, 80, 30)];
    [button setTitle:@"change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - context
- (void)setupGLProgram {
    [self initEarthProgram];
    [self initLineProgram];
}

- (void)initEarthProgram {
    //加载shader
    self.earthProgram = [[ZLGLProgram alloc] init];
    self.earthProgram.vShaderFile = @"shaderTexture12v";
    self.earthProgram.fShaderFile = @"shaderTexture12f";

    [self.earthProgram addAttribute:@"position"];
    [self.earthProgram addAttribute:@"textureCoor"];
    [self.earthProgram addUniform:@"projectionMatrix"];
    [self.earthProgram addUniform:@"modelViewMatrix"];
    [self.earthProgram addUniform:@"colorMap0"];

    [self.earthProgram compileAndLink];

    e_attributes[ATTRIBUTE_VERTEX] = [self.earthProgram attributeID:@"position"];
    e_attributes[ATTRIBUTE_TEXTURE_COORD] = [self.earthProgram attributeID:@"textureCoor"];
    e_uniforms[UNIFORM_PROJECTION_MATRIX] = [self.earthProgram uniformID:@"projectionMatrix"];
    e_uniforms[UNIFORM_MODEL_MATRIX] = [self.earthProgram uniformID:@"modelViewMatrix"];
    e_uniforms[UNIFORM_COLOR_MAP_0] = [self.earthProgram uniformID:@"colorMap0"];
    [self.earthProgram useProgrm];
}

- (void)initLineProgram {
    //加载shader
    self.linePorgram = [[ZLGLProgram alloc] init];
    self.linePorgram.vShaderFile = @"shaderTextureLinev";
    self.linePorgram.fShaderFile = @"shaderTextureLinef";
    
    [self.linePorgram addAttribute:@"position"];
//    [self.linePorgram addAttribute:@"textureCoor"];
    [self.linePorgram addUniform:@"projectionMatrix"];
    [self.linePorgram addUniform:@"modelViewMatrix"];
    [self.linePorgram addUniform:@"colorMap0"];
    
    [self.linePorgram compileAndLink];
    
    p_attributes[ATTRIBUTE_VERTEX] = [self.linePorgram attributeID:@"position"];
//    p_attributes[ATTRIBUTE_TEXTURE_COORD] = [self.linePorgram attributeID:@"textureCoor"];
    p_uniforms[UNIFORM_PROJECTION_MATRIX] = [self.linePorgram uniformID:@"projectionMatrix"];
    p_uniforms[UNIFORM_MODEL_MATRIX] = [self.linePorgram uniformID:@"modelViewMatrix"];
    p_uniforms[UNIFORM_COLOR_MAP_0] = [self.linePorgram uniformID:@"colorMap0"];
    [self.linePorgram useProgrm];
}

#pragma mark - data
- (void)setupData {
    float radius = 1.0f;     //球的半径
    float statckStep = (float) (M_PI / statck);//单位角度值
    float sliceStep = (float) (M_PI * 2 / slice);//水平圆递增的角度
    
    GLfloat pointArray[statck+1][slice+1][5];
    for (int i = 0; i <= statck; i++) {
        float alpha0 = (float) (i * statckStep);
        
        float y = (float) (radius * cos(alpha0));
        float r = (float) (radius * sin(alpha0));
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
    
    GLfloat earthDrawArray[statck+1][slice+1][2][5];
    for (int i = 0; i < statck; i++) {
        for (int j = 0; j <= slice; j++) {
            earthDrawArray[i][j][0][0] = pointArray[i+1][j][0];
            earthDrawArray[i][j][0][1] = pointArray[i+1][j][1];
            earthDrawArray[i][j][0][2] = pointArray[i+1][j][2];
            earthDrawArray[i][j][0][3] = pointArray[i+1][j][3];
            earthDrawArray[i][j][0][4] = pointArray[i+1][j][4];

            earthDrawArray[i][j][1][0] = pointArray[i][j][0];
            earthDrawArray[i][j][1][1] = pointArray[i][j][1];
            earthDrawArray[i][j][1][2] = pointArray[i][j][2];
            earthDrawArray[i][j][1][3] = pointArray[i][j][3];
            earthDrawArray[i][j][1][4] = pointArray[i][j][4];
        }
    }
    
    CGFloat mRadius = 1.2;
    GLfloat mPointArray[statck+1][slice+1][5];
    for (int i = 0; i <= statck; i++) {
        float alpha0 = (float) (i * statckStep);
        
        float y = (float) (mRadius * cos(alpha0));
        float r = (float) (mRadius * sin(alpha0));
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
    
    GLfloat lineDrawArray[statck+1][slice+1][2][5];
    for (int i = 0; i < statck; i++) {
        for (int j = 0; j <= slice; j++) {
            lineDrawArray[i][j][0][0] = mPointArray[i][j][0];
            lineDrawArray[i][j][0][1] = mPointArray[i][j][1];
            lineDrawArray[i][j][0][2] = mPointArray[i][j][2];
            lineDrawArray[i][j][0][3] = mPointArray[i][j][3];
            lineDrawArray[i][j][0][4] = mPointArray[i][j][4];
            
            lineDrawArray[i][j][1][0] = pointArray[i][j][0];
            lineDrawArray[i][j][1][1] = pointArray[i][j][1];
            lineDrawArray[i][j][1][2] = pointArray[i][j][2];
            lineDrawArray[i][j][1][3] = pointArray[i][j][3];
            lineDrawArray[i][j][1][4] = pointArray[i][j][4];
        }
    }
    
    // setupearth

    glGenVertexArraysOES(2, VAO);
    glBindVertexArrayOES(VAO[0]);
    
    glGenBuffers(1, &earthVBO);
    glBindBuffer(GL_ARRAY_BUFFER, earthVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(earthDrawArray), earthDrawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(e_attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(e_attributes[ATTRIBUTE_VERTEX]);
    glVertexAttribPointer(e_attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(e_attributes[ATTRIBUTE_TEXTURE_COORD]);

    glGenTextures(1, &textureBuffer);
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"pic_earth"];
    glUniform1i(e_uniforms[UNIFORM_COLOR_MAP_0], 0);
    
    // setupline
    
    glBindVertexArrayOES(VAO[1]);
    
    glGenBuffers(1, &lineVBO);
    glBindBuffer(GL_ARRAY_BUFFER, lineVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(lineDrawArray), lineDrawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(p_attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(p_attributes[ATTRIBUTE_VERTEX]);
}

- (void)updateLine {
    glUseProgram(self.linePorgram.programId);
    
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
}

- (void)updateEarth {
    glUseProgram(self.earthProgram.programId);

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
}

- (void)drawEarth {
    glUseProgram(self.earthProgram.programId);
    glBindVertexArrayOES(VAO[0]);
    if (isPoint) {
        glDrawArrays(GL_POINTS, 0,  ((statck+1) * 2 - 2) * (slice+1));
    } else {
        glDrawArrays(GL_TRIANGLE_STRIP, 0, ((statck+1) * 2 - 2) * (slice+1));
    }
}

- (void)drawLine {
    glUseProgram(self.linePorgram.programId);
    glBindVertexArrayOES(VAO[1]);
    glDrawArrays(GL_LINES, 0,  ((statck+1) * 2 - 2) * (slice+1));
}

#pragma mark - render
- (void)updateData {
    [self updateEarth];
    [self drawEarth];
    
    [self updateLine];
    [self drawLine];
}

- (void)draw {
//    [self drawEarth];
//    [self drawLine];
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

- (void)change:(id)sender {
    isPoint = !isPoint;
    xRotate = 0;
    yRotate = 0;
    [self render];
}

@end



