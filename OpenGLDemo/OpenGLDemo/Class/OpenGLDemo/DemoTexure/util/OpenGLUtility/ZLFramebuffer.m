//
//  ZLFramebuffer.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLFramebuffer.h"
#import "ZLContext.h"
#import <OpenGLES/ES2/glext.h>

@interface ZLFramebuffer()

@property (nonatomic, assign) GLuint defaultFramebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLuint depthRenderbuffer;

@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;

@end

@implementation ZLFramebuffer

#pragma mark - public
//- (void)setupFramebuffer {
//    if (ContextInstance.context) {
//        [EAGLContext setCurrentContext:ContextInstance.context];
//
//        if (!_defaultFramebuffer)
//            [self createFramebuffer];
//
//        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
//        glViewport(0, 0, _framebufferWidth, _framebufferHeight);
//    }
//}
//
//- (BOOL)presentRenderbuffer {
//    if (!ContextInstance.context) {
//        return NO;
//    }
//
//    [EAGLContext setCurrentContext:ContextInstance.context];
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
//    return [ContextInstance.context presentRenderbuffer:GL_RENDERBUFFER];
//}
//
//#pragma mark - framebuffer creater
//
//- (void)createFramebuffer {
//    if (ContextInstance.context && !_defaultFramebuffer) {
//        [EAGLContext setCurrentContext:ContextInstance.context];
//
//        // framebuffer
//        glGenFramebuffers(1, &_defaultFramebuffer);
//        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
//
//        //建立颜色缓冲区
//        glGenRenderbuffers(1, &_colorRenderbuffer);
//        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
////        [ContextInstance.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
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
//}
//
//- (void)deleteFramebuffer {
//    if (ContextInstance.context) {
//        [EAGLContext setCurrentContext:ContextInstance.context];
//
//        if (_defaultFramebuffer) {
//            glDeleteFramebuffers(1, &_defaultFramebuffer);
//            _defaultFramebuffer = 0;
//        }
//        if (_colorRenderbuffer) {
//            glDeleteRenderbuffers(1, &_colorRenderbuffer);
//            _colorRenderbuffer = 0;
//        }
//        if (_depthRenderbuffer) {
//            glDeleteRenderbuffers(1, &_depthRenderbuffer);
//            _depthRenderbuffer = 0;
//        }
//    }
//}
@end
