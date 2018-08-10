//
//  OpenGLDemo11Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/8.
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
    
}

- (NSString *)controllerTitle {
    return @"绘图";
}
@end
