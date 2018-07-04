//
//  OpenGLDemo12Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/8.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo12Controller.h"
#import "GLRender12View.h"

@interface OpenGLDemo12Controller ()

@end

@implementation OpenGLDemo12Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender12View alloc] init];
    [self createNavBarWithTitle:@"Demo12" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
