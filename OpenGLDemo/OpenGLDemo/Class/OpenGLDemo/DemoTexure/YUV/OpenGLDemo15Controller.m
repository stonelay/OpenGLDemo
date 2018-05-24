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
    [self createNavBarWithTitle:@"Demo15" withLeft:[UIImage imageNamed:@"icon_back"]];
    GLRender15View *view = (GLRender15View *)self.view;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"176x144_yuv420p" ofType:@"yuv"];
    
    NSData *reader = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"the reader length is %i", reader.length);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [view displayYUV420pData:[reader bytes] width:256 height:256];
    [view displayYUV420pData:[reader bytes] width:176 height:144];
//    });
    
    [view bk_whenTapped:^{
        [view displayYUV420pData:[reader bytes] width:176 height:144];
    }];
    
    
}
@end
