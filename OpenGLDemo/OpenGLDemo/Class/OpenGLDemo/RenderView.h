//
//  RenderView.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface RenderView : UIView

@property (nonatomic , strong) EAGLContext* myContext;

@property (nonatomic , strong) CAEAGLLayer* myEagLayer;
@property (nonatomic , assign) GLuint       myProgram;

//- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag;
//- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;

- (void)setupContext;

- (GLuint)setupProgaramVFile:(NSString *)vFile fFile:(NSString *)fFile;
@end
