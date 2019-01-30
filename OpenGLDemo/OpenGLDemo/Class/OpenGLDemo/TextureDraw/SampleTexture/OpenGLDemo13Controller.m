//
//  OpenGLDemo13Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo13Controller.h"
#import "GLRender13View.h"

@interface OpenGLDemo13Controller ()

@end

@implementation OpenGLDemo13Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender13View alloc] init];
    
}

- (NSString *)controllerTitle {
    return @"地球和线";
}

@end
