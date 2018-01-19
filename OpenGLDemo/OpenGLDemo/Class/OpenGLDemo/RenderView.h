//
//  RenderView.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenderView : UIView

- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag;
- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;

@end
