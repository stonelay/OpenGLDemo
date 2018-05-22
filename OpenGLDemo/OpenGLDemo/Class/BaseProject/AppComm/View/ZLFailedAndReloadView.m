//
//  ZLFailedAndReloadView.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLFailedAndReloadView.h"

@interface ZLFailedAndReloadView()

@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ZLFailedAndReloadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *noticeLabel = [UILabel labelWithText:@"您的手机网络不太顺畅哦"
                                            textColor:ZLGray(100)
                                                 font:14
                                          textAliment:NSTextAlignmentCenter];
        noticeLabel.backgroundColor = ZLClearColor;
        noticeLabel.frame = CGRectMake(0, 150, 200, 16);
        noticeLabel.centerX = self.width / 2;
        
        [self addSubview:noticeLabel];
        
        UILabel *tryAgainLabel = [UILabel labelWithText:@"再刷新试试"
                                              textColor:ZLGray(100)
                                                   font:14
                                            textAliment:NSTextAlignmentCenter];
        tryAgainLabel.backgroundColor = ZLClearColor;
        tryAgainLabel.frame = CGRectMake(0, 0, self.width, 16);
        tryAgainLabel.centerX = self.width / 2;
        tryAgainLabel.top = noticeLabel.bottom + 7;
        [self addSubview:tryAgainLabel];
        
        self.refreshButton = [[UIButton alloc] init];
        [self.refreshButton setBackgroundColor:ZLClearColor];
        [self.refreshButton setTitleColor:ZLRedColor forState:UIControlStateNormal];
        [self.refreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        [self.refreshButton addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventTouchUpInside];
        
//        self.refreshButton = [UIButton custom37OrangeButtonWithTitle:@"点击刷新" target:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        self.refreshButton.height = 32.f;
        self.refreshButton.width = 160.f;
        self.refreshButton.top = tryAgainLabel.bottom + 12.f;
        self.refreshButton.centerX = self.width/2.0;
        [self addSubview:self.refreshButton];
    }
    return self;
}

- (void)addActivityIndicator {
    [self.refreshButton setTitle:@" " forState:UIControlStateNormal];
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.activityIndicator.center = CGPointMake(self.refreshButton.width / 2, self.refreshButton.height / 2);
        self.activityIndicator.color = ZLGray(153);
    }
    if (!self.activityIndicator.superview) {
        [self.refreshButton addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    self.refreshButton.enabled = NO;
}

- (void)removeActivityIndicator {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    [self.refreshButton setTitle:@"重新加载" forState:UIControlStateNormal];
    self.refreshButton.enabled = YES;
}

- (void)beginRefresh {
    if ([self.delegate respondsToSelector:@selector(failedViewBeginReload:)]) {
        [self addActivityIndicator];
        [self.delegate failedViewBeginReload:self];
    }
}

- (void)didFinishLoading {
    [self removeActivityIndicator];
}

@end
