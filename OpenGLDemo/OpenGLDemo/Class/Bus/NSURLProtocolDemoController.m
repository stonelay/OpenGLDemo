//
//  NSURLProtocolDemoController.m
//  OpenGLDemo
//
//  Created by Lay on 2019/1/29.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import "NSURLProtocolDemoController.h"

#import "MyURLProtocol.h"

@interface NSURLProtocolDemoController ()

@end

@implementation NSURLProtocolDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:MyURLProtocol.class];
//    NSURLSession *session = [];
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
    [self sendQuery];
}

- (void)sendQuery {
    NSString *urlStr = @"http://www.baidu.com";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    
    //创建NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //开始任务
    [task resume];
}
@end
