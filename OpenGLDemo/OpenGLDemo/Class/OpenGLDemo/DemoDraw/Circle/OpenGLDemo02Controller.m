//
//  OpenGLDemo02Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo02Controller.h"
#import "GLRender02View.h"

/*
 画圆
 */

@interface OpenGLDemo02Controller ()

@end

@implementation OpenGLDemo02Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender02View alloc] init];
    [self createNavBarWithTitle:@"Demo02" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
