//
//  BaseWebController.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/11.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseWebController.h"

@interface BaseWebController () 

@end

@implementation BaseWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZLWhiteColor;
    
    [self addWebView];
    [self loadRequest];
    [self showNavigationBar];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"icon_back_nav"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationBackAction)
         forControlEvents:UIControlEventTouchUpInside];
    //    leftButton.left = 8;
    leftButton.centerY = STATUSBARHEIGHT + NAVBARCONTAINERHEIGHT / 2;
    [self.view addSubview:leftButton];
}

- (void)addWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVBARHEIGHT)];
    self.webView.backgroundColor = ZLWhiteColor;
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
}

-(void)loadRequest{
    
    if (self.url) {
        NSString *strUrl = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        
        if (![url.scheme isNotEmptyString] && [_url isNotEmptyString]) {
            if (![_url hasPrefix:@"http://"]) {
                NSString *preUrl = @"http://";
                _url = [NSString stringWithFormat:@"%@%@", preUrl, _url];
            }
        }
        
        if ([UserInfoService shareUserInfo].isLogin) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"sign"] = [UserInfoService shareUserInfo].userInfo.sign;
            
            _url = [_url addURLParamsFromDictionary:params];
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"platform"] = @"ios";
        params[@"versionName"] = [UIApplication sharedApplication].appVersion;
        
        _url = [_url addURLParamsFromDictionary:params];
        
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [self.webView loadRequest:requestObj];
    }
}

- (void)navigationBackAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else {
        [super navigationBackAction];
    }
}


#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *strUrl = [request.URL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    if ([AppScheme isEqualToString:url.scheme] || (0 < [url.scheme length]
                                                     && (![@"http" isEqualToString:url.scheme])
                                                     && (![@"https" isEqualToString:url.scheme]))) {
        
        [[ZLNavigationService sharedService] openUrl:request.URL.absoluteString];
        
        return NO;
        
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [ZLActivityIndicatorView showInView:self.view animated:YES];
    [self setTitle:@"加载中..."];
    
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(webViewLoadTime) userInfo:nil repeats:NO];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.shareTitle) {
        title = self.shareTitle;
    }
    
    [self setTitle:title];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
//    [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.shareTitle) {
        title = self.shareTitle;
    }
    [self setTitle:title];
    
}

@end
