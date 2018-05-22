//
//  OpenGLDemo12Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "OpenGLDemo15Controller.h"
#import "GLRender15View.h"

@interface OpenGLDemo15Controller ()

@end

@implementation OpenGLDemo15Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GLRender15View alloc] init];
    [self createNavBarWithTitle:@"Demo15" withLeft:[UIImage imageNamed:@"icon_back"]];
    GLRender15View *view = (GLRender15View *)self.view;
    
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 2.创建一个文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lena_256x256_yuv420p" ofType:@"yuv"];
    
    NSData *reader = [NSData dataWithContentsOfFile:filePath];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view displayYUV420pData:[reader bytes] width:300 height:300];
    });
    
}
@end
