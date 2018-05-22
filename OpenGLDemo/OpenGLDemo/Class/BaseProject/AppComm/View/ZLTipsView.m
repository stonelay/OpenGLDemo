//
//  ZLTipsView.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLTipsView.h"

@implementation ZLTipsView

- (id)initWithFrame:(CGRect)frame tips:(NSString *)tips {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ZLWhiteColor;
        if (!tips || tips.length == 0) {
            tips = @"还没有内容";
        }
        
        self.userInteractionEnabled = YES;
        
        UILabel *_tipsLabel = [UILabel labelWithText:tips
                                           textColor:ZLGray(153)
                                                font:14
                                         textAliment:NSTextAlignmentCenter];
        _tipsLabel.backgroundColor = ZLClearColor;
        _tipsLabel.frame = CGRectMake(0, 100, self.width, 15);
        [self addSubview:_tipsLabel];
    }
    
    return self;
}
@end
