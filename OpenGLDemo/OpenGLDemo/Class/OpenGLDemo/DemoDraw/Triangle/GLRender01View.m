//
//  GLRender01View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender01View.h"
#import "ZLGLProgram.h"

@interface GLRender01View() {
//    GLint attributes[ATTRIBUTE_VERTEX];
    GLint position;
}

@property (nonatomic, strong) ZLGLProgram *program;

@end

@implementation GLRender01View

- (instancetype)init {
    if (self = [super init]) {
        [self setupContext];
        [self setupGLProgram];  // shader
        [self setupData];       // data
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
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
//    self.program = [[ZLGLProgram alloc] init];
//    self.programId = [self setupProgaramVFile:@"shaderDrawv" fFile:@"shaderDrawf"];
    self.program = [[ZLGLProgram alloc] init];
    self.program.vShaderFile = @"shaderDrawv";
    self.program.fShaderFile = @"shaderDrawf";
    [self.program addAttribute:@"position"];
    [self.program compileAndLink];
    position = [self.program attributeID:@"position"];
//    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
}

#pragma mark - data
- (void)setupData {
    GLfloat attrArr[] = {
        0.5f,  -0.5f, -1.0f,
        0.0f, 0.5f,  -1.0f,
        -0.5f, -0.5f, -1.0f
    };
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
//    GLuint position0 = glGetAttribLocation(self.programId, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
    glEnableVertexAttribArray(position);
}

#pragma mark - render

- (void)render {
    
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [self presentFramebuffer];
}

- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    GLuint verShader, fragShader;
    GLint program = glCreateProgram();
    
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);
    
    // Free up no longer needed shader resources
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    return program;
}

- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar* source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
}


- (GLuint)setupProgaramVFile:(NSString *)vFile fFile:(NSString *)fFile {
    //读取文件路径
    NSString* vertFile = [[NSBundle mainBundle] pathForResource:vFile ofType:@"glsl"];
    NSString* fragFile = [[NSBundle mainBundle] pathForResource:fFile ofType:@"glsl"];
    
    GLuint myProgram;
    //加载shader
    myProgram = [self loadShaders:vertFile frag:fragFile];
    
    //链接
    glLinkProgram(myProgram);
    GLint linkSuccess;
    glGetProgramiv(myProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) { //连接错误
        GLchar messages[256];
        glGetProgramInfoLog(myProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"error%@", messageString);
    } else {
        NSLog(@"link ok");
        glUseProgram(myProgram); //成功便使用，避免由于未使用导致的的bug
    }
    return myProgram;
}


@end
