//
//  GLRender06View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender06View.h"

@interface GLRender06View(){
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint textureBuffer;
}

@property (nonatomic, strong) UISlider *xSlider;

@end

@implementation GLRender06View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
        [self setupData]; // data
        [self addComponent];
    }
    return self;
}

- (void)addComponent {
    [self addSubview:self.xSlider];
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

- (void)sliderValueChanged:(id)sender {
    [self render];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
//    self.myProgram = [self setupProgaramVFile:@"shaderTexture06v" fFile:@"shaderTexture06f"];
    
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexture06v";
    self.program.fShaderFile = @"shaderTexture06f";
    
    // attribute
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoor"];
    // uniform
    [self.program addUniform:@"rotateMatrix"];
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"textureCoor"];
    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"rotateMatrix"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    [self.program useProgrm];
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
    };
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
//    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
//    GLuint textureCoor = glGetAttribLocation(self.myProgram, "textureCoor");
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
//    GLuint texture = [self setupTexture:@"for_test02"];
    glGenTextures(1, &textureBuffer);
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"for_test02"];
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);

    
    // 旋转角度
    
//    获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
//    GLuint rotate = glGetUniformLocation(self.program.programId, "rotateMatrix");

    float radians = 0 * 3.14159f / 180.0f;

    float s = sin(radians);
    float c = cos(radians);

    //z轴旋转矩阵
    GLfloat zRotation[16] = { //
        c, -s, 0, 0, //
        s, c, 0, 0,//
        0, 0, 1.0, 0,//
        0.0, 0, 0, 1.0//
    };

    //设置旋转矩阵
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    
}

#pragma mark - render

- (void)updateData {
    float radians = self.xSlider.value * 3.14159f / 180.0f;
    
    float s = sin(radians);
    float c = cos(radians);
    
    //z轴旋转矩阵
    GLfloat zRotation[16] = { //
        c, -s, 0, 0, //
        s, c, 0, 0,//
        0, 0, 1.0, 0,//
        0.0, 0, 0, 1.0//
    };
    
    //设置旋转矩阵
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, (GLfloat *)&zRotation[0]);
}

- (void)draw {
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end

