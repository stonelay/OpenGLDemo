//
//  ServerPushDemoController.m
//  OpenGLDemo
//
//  Created by Lay on 2019/1/15.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import "ServerPushDemoController.h"

@interface ServerPushDemoController ()<NSURLSessionDelegate>

@property(nonatomic,strong)NSURLSession *session;

@end

@implementation ServerPushDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self sendRequest];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sendPushedRequest];
}

#pragma mark - 发送请求
- (void)sendRequest {
    NSURL *url = [NSURL URLWithString:@"https://localhost:443"];
//    NSURL *url = [NSURL URLWithString:@"https://h2o.examp1e.net"];
    
    //发送HTTPS请求是需要对网络会话设置代理的
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // 收到该次请求后，立即请求下次的内容
        [self sendPushedRequest];
    }];
    
    [dataTask resume];
}

- (void)sendPushedRequest {
    NSURL *url = [NSURL URLWithString:@"https://localhost:443/sources/test.js"];
//    NSURL *url = [NSURL URLWithString:@"https://h2o.examp1e.net/search/searchindex.js"];
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    [dataTask resume];
}

#pragma mark - URLSession Delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"didReceiveChallenge");
    // 这里还要设置下 plist 中设置 ATS
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"])
    {
        NSLog(@"NSURLAuthenticationMethodServerTrust");
        return;
    }
    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    NSArray *fetchTypes = @[ @"Unknown", @"Network Load", @"Server Push", @"Local Cache"];
    
    for(NSURLSessionTaskTransactionMetrics *transactionMetrics in [metrics transactionMetrics]) {
        
        NSLog(@"networkProtocolName[%@] isReusedConnection[%d] fetchTypes:%@ - %@", [transactionMetrics networkProtocolName], [transactionMetrics isReusedConnection], fetchTypes[[transactionMetrics resourceFetchType]], [[transactionMetrics request] URL]);
        
        if([transactionMetrics resourceFetchType] == NSURLSessionTaskMetricsResourceFetchTypeServerPush) {
            NSLog(@"Asset was server pushed");
        }
    }
}

@end
