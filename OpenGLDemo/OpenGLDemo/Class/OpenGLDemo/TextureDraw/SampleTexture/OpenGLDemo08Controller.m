//
//  OpenGLDemo08Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo08Controller.h"
#import "GLRender08View.h"

@interface OpenGLDemo08Controller ()

@end

@implementation OpenGLDemo08Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender08View alloc] init];
    
}

- (NSString *)controllerTitle {
    return @"没有整理之前的三维立方体";
}

@end
