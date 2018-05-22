//
//  BaseController.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLNavigationBar.h"
#import "ZLTabbarItem.h"
#import "ZLAlertView.h"
#import "ZLFailedAndReloadView.h"
#import "ZLYESNOView.h"

@class ZLTabbarController;

@interface BaseController : UIViewController<ZLReloadDelegate>

@property (nonatomic, strong) ZLNavigationBar *navigationBar;

@property (nonatomic, assign) BOOL needBlurEffect;
@property (nonatomic, assign) BOOL isHideNavigationBar;

/**
 tabbar
 */
@property (nonatomic, strong) ZLTabbarItem *tabbarItem;
@property (nonatomic, weak) ZLTabbarController *tabBarController;

/**
 通用的 页面 选择时的 附加参数
 */
@property (nonatomic, strong) NSDictionary *extraParams;

- (void)addBackButton:(NSString *)image;
- (void)addMockTitle:(NSString *)title;

- (void)setTitleColor:(UIColor *)color;

- (void)navigationBackAction;
- (void)showNavigationBar;
- (void)hideNavigationBar;

- (void)initComponent;
- (void)initData;

#pragma mark - alert
- (void)showAlert:(NSString *)message;
- (void)showAlert:(NSString *)message
   didClickButton:(ClickbuttonAtIndex)didClickBlock;
- (void)showAlert:(NSString *)message
   didClickButton:(ClickbuttonAtIndex)didClickBlock
     willDissmiss:(WillDismissionAtIndex)willDismissBlock
      didDissmiss:(DidDismissionAtIndex)didDismissBlock;

#pragma mark - showYESNO view
- (void)showMAltertTitle:(NSString *)title
                 message:(NSString *)message
               leftTitle:(NSString *)leftTitle
              rightTitle:(NSString *)rightTitle
              leftAction:(ClickAction)leftAction
             rightAction:(ClickAction)rightAction;
- (void)showMAltertTitle:(NSString *)title
                 message:(NSString *)message
              leftAction:(ClickAction)leftAction
             rightAction:(ClickAction)rightAction;

#pragma mark - tips
- (void)showTips:(NSString *)tips;
- (void)showTips:(NSString *)tips onView:(UIView *)onView;
- (void)showTips:(NSString *)tips onView:(UIView *)onView offsetTop:(CGFloat)top;
- (void)hideTips;

#pragma mark - failed view
- (void)showFailedOnView:(UIView *)onView;
- (void)showFaildView;
- (void)hideFailedView;

#pragma mark - notice
- (void)showNotice:(NSString *)notice;
- (void)showNotice:(NSString *)notice duration:(NSTimeInterval)duration;


@end
