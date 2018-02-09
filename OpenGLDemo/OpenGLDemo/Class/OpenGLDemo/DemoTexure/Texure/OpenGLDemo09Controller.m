//
//  OpenGLDemo09Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/7.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo09Controller.h"
#import "GLRender09View.h"

@interface OpenGLDemo09Controller ()

@end

@implementation OpenGLDemo09Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender09View alloc] init];
    [self createNavBarWithTitle:@"Demo09" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
