//
//  OpenGLDemo11Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/26.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo11Controller.h"
#import "GLRender11View.h"

@interface OpenGLDemo11Controller ()

@end

@implementation OpenGLDemo11Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender11View alloc] init];
//    [self createNavBarWithTitle:@"Demo11" withLeft:[UIImage imageNamed:@"icon_back"]];
}

@end
