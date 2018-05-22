//
//  ZLAlertView.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/8.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLAlertView;
typedef void (^ClickbuttonAtIndex)(ZLAlertView *alertView, NSUInteger buttonIndex);
typedef void (^WillDismissionAtIndex)(ZLAlertView *alertView, NSUInteger buttonIndex);
typedef void (^DidDismissionAtIndex)(ZLAlertView *alertViewm, NSUInteger buttonIndex);

@interface ZLAlertView : UIView
@property (nonatomic, strong) UIWindow  *window;
@property (nonatomic, strong) UIView    *overlayView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *messageLabel;
@property (nonatomic, strong) UILabel   *messageLabel2;
@property (nonatomic, strong) UIView    *containerView;

@property (nonatomic, copy) ClickbuttonAtIndex  clickButtonBlock;
@property (nonatomic, copy) WillDismissionAtIndex willDismissBlock;
@property (nonatomic, copy) DidDismissionAtIndex didDismissBlock;


- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           message2:(NSString *)message2
      containerView:(UIView *)containerView
 confirmButtonTitle:(NSString *)confirmButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)show;

@end
