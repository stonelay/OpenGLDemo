//
//  OpenGLDemo07Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo07Controller.h"
#import "GLRender07View.h"

@interface OpenGLDemo07Controller ()

@end

@implementation OpenGLDemo07Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender07View alloc] init];
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
}

- (NSString *)controllerTitle {
    return @"整理之前的renderView";
}


@end
