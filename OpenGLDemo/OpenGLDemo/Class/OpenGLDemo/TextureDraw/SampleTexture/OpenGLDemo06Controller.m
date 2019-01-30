//
//  OpenGLDemo06Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo06Controller.h"
#import "GLRender06View.h"

/**
 texture 旋转
 */
@interface OpenGLDemo06Controller ()

@end

@implementation OpenGLDemo06Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender06View alloc] init];
    
}

- (NSString *)controllerTitle {
    return @"纹理贴图旋转";
}

@end
