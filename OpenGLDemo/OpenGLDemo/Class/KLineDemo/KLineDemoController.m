//
//  KLineDemoController.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "KLineDemoController.h"

@interface KLineDemoController ()

@end

@implementation KLineDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
}

- (NSString *)controllerTitle {
    return @"KLine";
}
@end
