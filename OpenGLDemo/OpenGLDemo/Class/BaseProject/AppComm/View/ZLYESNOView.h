//
//  ZLYESNOView.h
//  Caifuguanjia
//
//  Created by LayZhang on 2018/1/16.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLYESNOView;
typedef void (^ClickAction)(ZLYESNOView *alertView);

@interface ZLYESNOView : UIView

@property (nonatomic, strong) UIButton  *maskView;
@property (nonatomic, strong) UIView    *backView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *messageLabel;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) ClickAction leftAction;
@property (nonatomic, copy) ClickAction rightAction;


- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                    leftTitle:(NSString *)leftTitle
                   rightTitle:(NSString *)rightTitle;

- (void)show;

@end
