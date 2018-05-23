//
//  GLRender15View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender15View.h"
#import "GLLoadTool.h"

@interface GLRender15View() {
    
    GLint uniforms[NUM_UNIFORMS];
    GLint attributes[NUM_ATTRIBUTES];
}

@end

@implementation GLRender15View

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
    
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexure15v";
    self.program.fShaderFile = @"shaderTexure15f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"TexCoordIn"];
    [self.program addUniform:@"SamplerY"];
    [self.program addUniform:@"SamplerU"];
    [self.program addUniform:@"SamplerV"];
    [self.program compileAndLink];
    //    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    uniforms[UNIFORM_COLOR_Y] = [self.program uniformID:@"SamplerY"];
    uniforms[UNIFORM_COLOR_U] = [self.program uniformID:@"SamplerU"];
    uniforms[UNIFORM_COLOR_V] = [self.program uniformID:@"SamplerV"];
    attributes[ATTRIBUTE_POSITION] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"TexCoordIn"];
    [self.program useProgrm];
    
    //    [GLLoadTool setupTexture:@"pic_earth" buffer:earthBuffer texure:GL_TEXTURE0];
    //    [GLLoadTool setupTexture:<#(NSString *)#> buffer:<#(GLuint)#> texure:<#(GLenum)#>];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_Y]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_U]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_V]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

#pragma mark - data
- (void)setupData {
//    GLfloat attrArr[] = {
//        0.5f,  -0.5f, -1.0f,
//        0.5f,  0.5f,  -1.0f,
//        -0.5f, -0.5f, -1.0f,
//        -0.5f, 0.5f, -1.0f,
//    };
//
//    GLuint attrBuffer;
//    glGenBuffers(1, &attrBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
//    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
//    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
//    glUniform1i(uniforms[UNIFORM_COLOR_Y], 0);
//    glUniform1i(uniforms[UNIFORM_COLOR_U], 1);
//    glUniform1i(uniforms[UNIFORM_COLOR_V], 2);
    
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    
    static const GLfloat coordVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
    
    
    // Update attribute values
//    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
//    glEnableVertexAttribArray(ATTRIB_VERTEX);
//
//
//    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, coordVertices);
//    glEnableVertexAttribArray(ATTRIB_TEXTURE);
    
    
    glVertexAttribPointer(attributes[ATTRIBUTE_POSITION], 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_POSITION]);
    //    glVertexPointer(3, GL_FLOAT, 0,(void *)NULL);
    
    //    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 2, GL_FLOAT, 0, 0, coordVertices);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    //    GLuint texture = [self setupTexture:@"for_test02"];
    //    [GLLoadTool setupTexture:@"for_test02" texure:GL_TEXTURE0];
//    [GLLoadTool setupTexture:@"for_test02" buffer:textBuffer texure:GL_TEXTURE0];
    
    
    //    GLuint buffer0 = glGetUniformLocation(self.program.programId, "colorMap0");
    //    glUniform1i(buffer0, 0);
//    glUniform1i(uniforms[UNIFORM_COLOR_Y], 0);
//    glUniform1i(uniforms[UNIFORM_COLOR_U], 0);
//    glUniform1i(uniforms[UNIFORM_COLOR_V], 0);
    
    // Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [self presentRenderbuffer];
}


#pragma mark - 接口
- (void)displayYUV420pData:(void *)data width:(GLsizei)w height:(GLsizei)h {
    
    [self setVideoSize:w height:h];
    
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_Y]);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_RED_EXT, GL_UNSIGNED_BYTE, data);
    
    //[self debugGlError];
    
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_U]);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w/2, h/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data + w * h);
    
    // [self debugGlError];
    
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_V]);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w/2, h/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data + w * h * 5 / 4);
    
    //[self debugGlError];
    
    [self render];
}

- (void)setVideoSize:(GLsizei)width height:(GLsizei)height
{
    
    void *blackData = malloc(width * height * 1.5);
    if(blackData)
        //bzero(blackData, width * height * 1.5);
        memset(blackData, 0x0, width * height * 1.5);
    
//    [EAGLContext setCurrentContext:_glContext];
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_Y]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width, height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_U]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height);
    
    glBindTexture(GL_TEXTURE_2D, uniforms[UNIFORM_COLOR_V]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height * 5 / 4);
    free(blackData);
}


@end
