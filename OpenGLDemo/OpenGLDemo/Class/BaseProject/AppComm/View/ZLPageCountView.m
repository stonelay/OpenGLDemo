//
//  ZLPageCountView.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLPageCountView.h"
#define FontSize 14

@implementation ZLPageCountView

- (instancetype)initWithPageNumber:(NSInteger)number {
    CGSize currentPageSzie = [self sizeForNumberOfPages:number];
    self = [super initWithFrame:CGRectMake(0, 0, currentPageSzie.width + 20.f, 20.f)];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = ZLRGBA(0, 0, 0, 0.3);
        self.numberOfPages = number;
        
        [self addSubview:self.textLabel];
        
        self.currentPage = 0;
    }
    return self;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pages {
    NSString *maxString = [NSString stringWithFormat:@"%ld/%ld", (long)pages, (long)pages];
    CGSize currentPageSzie = [maxString sizeWithAttributes:@{NSFontAttributeName:ZLNormalFont(FontSize)}];
    return currentPageSzie;
}

#pragma mark - properties
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel labelWithText:@""
                                  textColor:ZLWhiteColor
                                       font:FontSize
                                textAliment:NSTextAlignmentCenter];
        _textLabel.backgroundColor = ZLClearColor;
    }
    return _textLabel;
}


- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages < 0) {
        _numberOfPages = 0;
    } else {
        _numberOfPages = numberOfPages;
    }
    if (_numberOfPages <= 1) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < 0) {
        _currentPage = 0;
    } else if (currentPage > self.numberOfPages) {
        _currentPage = self.numberOfPages;
    } else {
        _currentPage = currentPage;
    }
    self.textLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentPage + 1, (long)self.numberOfPages];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
    self.layer.cornerRadius = self.height / 2;
}

@end
