//
//  ZLFramebuffer.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

// Attribute index.
enum {
    ATTRIBUTE_VERTEX,
    ATTRIBUTE_TEXTURE_COORD,
    ATTRIBUTE_COLOR,
    NUM_ATTRIBUTES
};

// Uniform index.
enum {
    UNIFORM_PROJECTION_MATRIX,
    UNIFORM_MODEL_MATRIX,
    UNIFORM_COLOR_MAP_0,
    NUM_UNIFORMS
};

@interface ZLFramebuffer : NSObject

- (void)setupFramebuffer;
- (BOOL)presentRenderbuffer;

@end
