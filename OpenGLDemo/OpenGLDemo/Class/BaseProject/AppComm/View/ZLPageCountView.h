//
//  ZLPageCountView.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPageCountView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

- (instancetype)initWithPageNumber:(NSInteger)number;
- (CGSize)sizeForNumberOfPages:(NSInteger)pages;

@end
