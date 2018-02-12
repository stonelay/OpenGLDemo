//
//  ZLGLView.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/9.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


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


@interface ZLGLView : UIView

@property (nonatomic, strong) EAGLContext *context;

- (void)setupFramebuffer;
- (BOOL)presentRenderbuffer;

@end
