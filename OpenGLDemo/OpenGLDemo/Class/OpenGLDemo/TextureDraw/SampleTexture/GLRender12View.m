//
//  GLRender08View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender12View.h"
#import "GLESMath.h"


#import "ZLGLProgram.h"

static int statck = 20;         //statck：切片----把球体横向切成几部分
static int slice = 50;//纵向切几部分

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
    
    BOOL isPoint;
}

@end

@implementation GLRender12View

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
    [button setTitle:@"Change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self setupFramebuffer];
//    [self render];
    
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    self.program.vShaderFile = @"shaderTexture12v";
    self.program.fShaderFile = @"shaderTexture12f";
    
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoor"];
    [self.program addUniform:@"projectionMatrix"];
    [self.program addUniform:@"modelViewMatrix"];
    [self.program addUniform:@"colorMap0"];
    
    [self.program compileAndLink];
    
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"textureCoor"];
    uniforms[UNIFORM_PROJECTION_MATRIX] = [self.program uniformID:@"projectionMatrix"];
    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"modelViewMatrix"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
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
    
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(drawArray), drawArray, GL_STATIC_DRAW);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    glGenTextures(1, &textureBuffer);
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"pic_earth"];
    //    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
}

#pragma mark - render
- (void)updateData {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    NSLog(@"width %f, height %f", width, height);
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    // 透视投影
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 100.0); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    
    // 需要计算 正反面
    glEnable(GL_CULL_FACE);
    
    /*------------------------------------------------------------------------*/
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
}

- (void)draw {
    if (isPoint) {
        glDrawArrays(GL_POINTS, 0,  ((statck+1) * 2 - 2) * (slice+1));
    } else {
        glDrawArrays(GL_TRIANGLE_STRIP, 0, ((statck+1) * 2 - 2) * (slice+1));
    }
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

- (void)change:(id)sender {
    isPoint = !isPoint;
    [self render];
}

@end


