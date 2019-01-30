//
//  OpenGLDemo12Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo15Controller.h"
#import "GLRender15View.h"

// TODO 显示一张 YUV 图片
@interface OpenGLDemo15Controller ()

@end

@implementation OpenGLDemo15Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender15View alloc] init];
    GLRender15View *view = (GLRender15View *)self.view;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"176x144_yuv420p" ofType:@"yuv"];
    NSData *reader = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"the reader length is %lu", (unsigned long)reader.length);

    [view displayYUV420pData:[reader bytes] width:176 height:144];
    
    [view bk_whenTapped:^{
        [view displayYUV420pData:[reader bytes] width:176 height:144];
    }];
}

- (NSString *)controllerTitle {
    return @"解析显示YUV格式文件，点击切换";
}

@end
