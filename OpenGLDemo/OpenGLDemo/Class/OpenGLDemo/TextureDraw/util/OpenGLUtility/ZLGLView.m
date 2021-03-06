//
//  ZLGLView.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/9.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGLView.h"

@interface ZLGLView()

@property (nonatomic, assign) GLuint defaultFramebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLuint depthRenderbuffer;
//@property (nonatomic, assign) GLuint texBuffer;

@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;

@end

@implementation ZLGLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
        [self setupContext];
    }
    return self;
}

- (void)setupLayer {
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = YES; // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
                                kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
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

#pragma mark - property
- (void)setContext:(EAGLContext *)context {
    if (_context == context) return;
    
    [self deleteFramebuffer];
    _context = context;
    [EAGLContext setCurrentContext:_context];
}

#pragma mark - public
- (void)setupFramebuffer {
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        
        if (!_defaultFramebuffer)
            [self createFramebuffer];
        
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
        glViewport(0, 0, _framebufferWidth, _framebufferHeight);
    }
}

- (BOOL)presentRenderbuffer {
    if (!_context) {
        return NO;
    }
    
    [EAGLContext setCurrentContext:_context];
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    return [_context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - framebuffer creater

- (void)createFramebuffer {
    if (_context && !_defaultFramebuffer) {
        NSLog(@"create frame buffer..");
        [EAGLContext setCurrentContext:_context];
        
        // framebuffer
        glGenFramebuffers(1, &_defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);

        //建立颜色缓冲区
        glGenRenderbuffers(1, &_colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);

        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);

        //建立深度缓冲区
        glGenRenderbuffers(1, &_depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _framebufferWidth, _framebufferHeight);

        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
        glEnable(GL_DEPTH_TEST);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
}

- (void)deleteFramebuffer {
    if (_context) {
        NSLog(@"delete frame buffer..");
        [EAGLContext setCurrentContext:_context];
        
        if (_defaultFramebuffer) {
            glDeleteFramebuffers(1, &_defaultFramebuffer);
            _defaultFramebuffer = 0;
        }
        if (_colorRenderbuffer) {
            glDeleteRenderbuffers(1, &_colorRenderbuffer);
            _colorRenderbuffer = 0;
        }
        if (_depthRenderbuffer) {
            glDeleteRenderbuffers(1, &_depthRenderbuffer);
            _depthRenderbuffer = 0;
        }
//        if (_texBuffer) {
//            glDeleteTextures(1, &_texBuffer);
//            _texBuffer = 0;
//        }
    }
}

#pragma mark - system

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self deleteFramebuffer];
    [self setupFramebuffer];
    [self render];
}

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self updateData];
    [self draw];
    [self presentRenderbuffer];
}

- (void)updateData {}
- (void)draw {}

- (void)dealloc {
    ZLFuncLineLog(@"dealloc .....");
    [self deleteFramebuffer];
    _context = nil;
}

- (void)setupTexture:(GLenum)texture buffer:(GLuint)buffer fileName:(NSString *)fileName {
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
    
    glActiveTexture(texture);
    
    glBindTexture(GL_TEXTURE_2D, buffer);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
}

@end
