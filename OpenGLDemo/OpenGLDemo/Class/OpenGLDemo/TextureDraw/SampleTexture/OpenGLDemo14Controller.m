//
//  OpenGLDemo14Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/15.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo14Controller.h"
#import "GLRender14View.h"

@interface OpenGLDemo14Controller ()

@end

@implementation OpenGLDemo14Controller

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view = [[GLRender14View alloc] init];
    [self.view addSubview:[[GLRender14View alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)]];
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
}

- (NSString *)controllerTitle {
    return @"Core Graphics";
}

@end
