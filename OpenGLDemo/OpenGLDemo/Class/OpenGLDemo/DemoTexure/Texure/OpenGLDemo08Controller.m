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
    [self createNavBarWithTitle:@"Demo08" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
