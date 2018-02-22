//
//  ZLTestRenderView.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLTestRenderView.h"

@interface ZLTestRenderView()

@property (nonatomic, assign) GLuint defaultFramebuffer;

@property (nonatomic, assign) GLuint depthRenderbuffer;

@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;

@end

@implementation ZLTestRenderView


+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = YES; // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
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
    glBindRenderbuffer(GL_RENDERBUFFER, _imageRenderbuffer);
    return [_context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - framebuffer creater

- (void)createFramebuffer {
    if (_context && !_defaultFramebuffer) {
        [EAGLContext setCurrentContext:_context];
        
        // framebuffer
        glGenFramebuffers(1, &_defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
        
        //建立颜色缓冲
        glGenRenderbuffers(1, &_imageRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _imageRenderbuffer);
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
        
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _imageRenderbuffer);
        
        //////
        GLuint textureId;
        glGenTextures(1, &textureId);
        glBindTexture(GL_TEXTURE_2D, textureId);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, TEXTURE_WIDTH, TEXTURE_HEIGHT, 0,
//                     GL_RGBA, GL_UNSIGNED_BYTE, 0);
//        glBindTexture(GL_TEXTURE_2D, 0);
        //////
        
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureId, 0);
        //建立深度缓冲区
        glGenRenderbuffers(1, &_depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _framebufferWidth, _framebufferHeight);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
        glEnable(GL_DEPTH_TEST);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)deleteFramebuffer {
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        
        if (_defaultFramebuffer) {
            glDeleteFramebuffers(1, &_defaultFramebuffer);
            _defaultFramebuffer = 0;
        }
        if (_imageRenderbuffer) {
            glDeleteRenderbuffers(1, &_imageRenderbuffer);
            _imageRenderbuffer = 0;
        }
        if (_depthRenderbuffer) {
            glDeleteRenderbuffers(1, &_depthRenderbuffer);
            _depthRenderbuffer = 0;
        }
    }
}

#pragma mark - system
- (void)layoutSubviews {
    [self deleteFramebuffer];
    //    [self setupFramebuffer];
}

- (void)dealloc {
    ZLFuncLineLog(@"dealloc .....");
    [self deleteFramebuffer];
    _context = nil;
}

@end
