//
//  OpenGLDemo01Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo01Controller.h"
#import "GLRender01View.h"

/**
 * opengl 画 一个三角形
 */
@interface OpenGLDemo01Controller ()

@end

@implementation OpenGLDemo01Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender01View alloc] init];
    [self createNavBarWithTitle:@"Demo01" withLeft:[UIImage imageNamed:@"icon_back"]];
    
}


@end
