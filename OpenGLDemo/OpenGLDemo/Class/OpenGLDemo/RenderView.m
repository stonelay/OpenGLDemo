//
//  RenderView.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "RenderView.h"
#import <OpenGLES/ES2/gl.h>

@implementation RenderView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupLayer];      // layer
        [self setupContext];    // context
    }
    return self;
}

#pragma mark - context
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
    self.myContext = context;
}

- (void)setupLayer {
    self.myEagLayer = (CAEAGLLayer*) self.layer;
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]]; //设置放大倍数
    self.myEagLayer.opaque = YES; // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    self.myEagLayer.drawableProperties =
    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

#pragma mark - shader
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

@end
