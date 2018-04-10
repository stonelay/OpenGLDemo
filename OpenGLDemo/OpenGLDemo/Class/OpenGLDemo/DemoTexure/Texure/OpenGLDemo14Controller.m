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
    self.view = [[GLRender14View alloc] init];
    [self createNavBarWithTitle:@"Demo13" withLeft:[UIImage imageNamed:@"icon_back"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
