//
//  OpenGLDemo04Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo04Controller.h"
#import "GLRender04View.h"

/**
 单张 纹理
 和 直线
 */
@interface OpenGLDemo04Controller ()

@end

@implementation OpenGLDemo04Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender04View alloc] init];
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
}

- (NSString *)controllerTitle {
    return @"贴图和线条";
}

@end
