//
//  ZLContext.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLContext.h"
#import "ZLGLProgram.h"
#import <OpenGLES/ES2/glext.h>

@interface ZLContext() {
    EAGLContext *_context;
}


@property (nonatomic, assign) GLuint defaultFramebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLuint depthRenderbuffer;

@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;

//@property (nonatomic, strong) ZLGLProgram *program;

@end

@implementation ZLContext

+ (instancetype)shareContext {
    static ZLContext *context = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[ZLContext alloc] init];
    });
    return context;
}

+ (void)useContext {
    EAGLContext *context = [ContextInstance context];
    if ([EAGLContext currentContext] != context) {
        [EAGLContext setCurrentContext:context];
    }
}

#pragma mark - property
- (EAGLContext *)context {
    if (_context == nil) {
        _context = [self createContext];
        [EAGLContext setCurrentContext:_context];
        glDisable(GL_DEPTH_TEST);
    }
    return _context;
}

- (void)setContext:(EAGLContext *)context {
    if (_context == context) return;
    
    [self deleteFramebuffer];
    _context = context;
    [EAGLContext setCurrentContext:_context];
}

- (EAGLContext *)createContext {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        return nil;
    }
    return context;
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
//    if (_context && !_defaultFramebuffer) {
//        [EAGLContext setCurrentContext:_context];
//        
//        // framebuffer
//        glGenFramebuffers(1, &_defaultFramebuffer);
//        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
//        
//        //建立颜色缓冲区
//        glGenRenderbuffers(1, &_colorRenderbuffer);
//        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
//        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
//        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
//        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
//        
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
//        
//        //建立深度缓冲区
//        glGenRenderbuffers(1, &_depthRenderbuffer);
//        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
//        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _framebufferWidth, _framebufferHeight);
//        
//        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
//        glEnable(GL_DEPTH_TEST);
//        
//        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
//            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
//    }
}

- (void)deleteFramebuffer {
    if (_context) {
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
    }
}


@end
