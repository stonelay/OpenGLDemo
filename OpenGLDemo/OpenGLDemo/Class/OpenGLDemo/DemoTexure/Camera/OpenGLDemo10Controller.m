//
//  OpenGLDemo10Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/12.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo10Controller.h"
#import "GLRender10View.h"

@interface OpenGLDemo10Controller ()

@end

@implementation OpenGLDemo10Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender10View alloc] init];
    [self createNavBarWithTitle:@"Demo10" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end