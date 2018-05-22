//
//  ZLNavigationBar.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/8.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLNavigationBar : UIView

/**
 title
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;


/**
 left button
 */
@property (nonatomic, strong) UIView *leftButton;

/**
 right button
 */
@property (nonatomic, strong) UIView *rightButton;      // 第一个
@property (nonatomic, strong) UIView *rightDesButton;   // 第二个

/**
 middle view
 */
@property (nonatomic, strong) UIView *middleView; 

/**
 主界面
 */
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIVisualEffectView *effectView;


- (void)setTitleColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame needBlurEffect:(BOOL)needBlurEffect;
- (void)setBottomBorderColor:(UIColor*)color;

@end
