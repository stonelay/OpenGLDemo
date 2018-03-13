//
//  GLLoadTool.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/26.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLLoadTool : NSObject

+ (void)setupTexture:(NSString *)fileName  buffer:(GLuint)buffer texure:(GLenum)texure;

@end
