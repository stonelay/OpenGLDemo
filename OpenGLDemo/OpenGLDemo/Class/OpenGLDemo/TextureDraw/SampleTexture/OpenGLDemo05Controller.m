//
//  OpenGLDemo05Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo05Controller.h"
#import "GLRender05View.h"

/**
 多张纹理
 */
@interface OpenGLDemo05Controller ()

@end

@implementation OpenGLDemo05Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender05View alloc] init];
    [self createNavBarWithTitle:@"Demo05" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
