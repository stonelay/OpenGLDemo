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
}

@end

@implementation GLRender06View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
//    self.myProgram = [self setupProgaramVFile:@"shaderTexure06v" fFile:@"shaderTexure06f"];
    
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexure06v";
    self.program.fShaderFile = @"shaderTexure06f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"texureCoor"];
    [self.program addUniform:@"rotateMatrix"];
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"texureCoor"];
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
    
//    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(attrArr[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attrArr[ATTRIBUTE_VERTEX]);
    
//    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
    glVertexAttribPointer(attrArr[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attrArr[ATTRIBUTE_TEXTURE_COORD]);
    
    GLuint texture = [self setupTexture:@"for_test02"];
    
    
//    获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
//    GLuint rotate = glGetUniformLocation(self.program.programId, "rotateMatrix");

    float radians = 100 * 3.14159f / 180.0f;

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
    glUniformMatrix4fv(uniforms[uniforms[UNIFORM_MODEL_MATRIX]], 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    [self presentRenderbuffer];
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

