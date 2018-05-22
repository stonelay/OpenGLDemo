//
//  BaseWebController.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/11.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseController.h"

@interface BaseWebController : BaseController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareImage;
@property (nonatomic, strong) NSString *shareDesc;

@property (nonatomic, strong) UIWebView *webView;

- (void)loadRequest;
- (void)addWebView;

@end
