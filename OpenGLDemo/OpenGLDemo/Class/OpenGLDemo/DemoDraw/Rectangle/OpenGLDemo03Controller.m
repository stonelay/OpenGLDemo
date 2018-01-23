//
//  OpenGLDemo03Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo03Controller.h"
#import "GLRender03View.h"

/*
 矩形
 */
@interface OpenGLDemo03Controller ()

@end

@implementation OpenGLDemo03Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender03View alloc] init];
    [self createNavBarWithTitle:@"Demo03" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
