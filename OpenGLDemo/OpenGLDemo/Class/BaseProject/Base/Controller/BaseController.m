//
//  BaseController.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseController.h"
#import "ZLTipsView.h"


@interface BaseController ()

@property (nonatomic, strong) ZLTipsView *tipsView;
@property (nonatomic, strong) ZLFailedAndReloadView *failedView;

@end

@implementation BaseController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ZLFuncLineLog();
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ZLFuncLineLog();
    //    DBG(@"viewWillDisappear %@", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZLThemeCtrInstance.backgroundColor;
    [self.navigationController.navigationBar setHidden:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.needBlurEffect = NO;
    [self initComponent];
}

- (void)initComponent {}
- (void)initData {}

#pragma mark - override uiviewcontroller settitle
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (_navigationBar) {
        [_navigationBar setTitle:title];
    }
}

- (void)setTitleColor:(UIColor *)color {
    if (_navigationBar) {
        [_navigationBar setTitleColor:color];
    }
}

- (void)addBackButton:(NSString *)image {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationBackAction)
         forControlEvents:UIControlEventTouchUpInside];
    leftButton.centerY = STATUSBARHEIGHT + NAVBARCONTAINERHEIGHT / 2;
    [self.view addSubview:leftButton];
}

- (void)addMockTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.centerY = STATUSBARHEIGHT + NAVBARCONTAINERHEIGHT / 2;
    titleLabel.centerX = SCREENWIDTH / 2;
    [self.view addSubview:titleLabel];
}

- (void)showNavigationBar {
    
    if (self.isHideNavigationBar) {
        ZLWarningLog(@"navigation is hide, can not show!");
        return;
    }
    
    if (!_navigationBar) {
        _navigationBar = [[ZLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, NAVBARHEIGHT) needBlurEffect:self.needBlurEffect];
        _navigationBar.clipsToBounds = YES;
        _navigationBar.backgroundColor = ZLThemeCtrInstance.navigationBackgroundColor;
        _navigationBar.tintColor = ZLThemeCtrInstance.navigationButtonColor;
        _navigationBar.title = self.title;
        
        [self.view addSubview:_navigationBar];
    }
    
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithTarget:self
                                                   action:@selector(navigationBackAction)
                                         forControlEvents:UIControlEventTouchUpInside];
        UIImage *backImage = [UIImage imageNamed:@"icon_yue_back"];
        [backButton setImage:backImage forState:UIControlStateNormal];
        backButton.size = CGSizeMake(40, 40);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [_navigationBar setLeftButton:backButton];
    }
    [_navigationBar setBottomBorderColor:ZLThemeCtrInstance.navigationBottomBorderColor];
    
    _navigationBar.hidden = NO;
}

- (void)hideNavigationBar {
    if (_navigationBar) {
        _navigationBar.hidden = YES;
    }
}

- (void)navigationBackAction {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - alert
- (void)showAlert:(NSString *)message {
    [self showAlert:message didClickButton:nil willDissmiss:nil didDissmiss:nil];
}

- (void)showAlert:(NSString *)message didClickButton:(ClickbuttonAtIndex)didClickBlock {
    [self showAlert:message
     didClickButton:didClickBlock
       willDissmiss:nil didDissmiss:nil];
}

- (void)showAlert:(NSString *)message
   didClickButton:(ClickbuttonAtIndex)didClickBlock
     willDissmiss:(WillDismissionAtIndex)willDismissBlock
      didDissmiss:(DidDismissionAtIndex)didDismissBlock {
    ZLAlertView *alertView = [[ZLAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       message2:nil
                                                  containerView:nil
                                             confirmButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    if (didClickBlock) {
        alertView.clickButtonBlock = didClickBlock;
    }
    if (willDismissBlock) {
        alertView.willDismissBlock = willDismissBlock;
    }
    if (didDismissBlock) {
        alertView.didDismissBlock = didDismissBlock;
    }
    [alertView show];
}

#pragma mark - showYESNOView
- (void)showMAltertTitle:(NSString *)title
                 message:(NSString *)message
               leftTitle:(NSString *)leftTitle
              rightTitle:(NSString *)rightTitle
              leftAction:(ClickAction)leftAction
             rightAction:(ClickAction)rightAction {
    ZLYESNOView *ynView = [[ZLYESNOView alloc] initWithTitle:title message:message
                                                   leftTitle:leftTitle rightTitle:rightTitle];
    ynView.leftAction = leftAction;
    ynView.rightAction = rightAction;
//    [self.view addSubview:ynView];
    [[UIApplication sharedApplication].keyWindow addSubview:ynView];
    [ynView show];
}

- (void)showMAltertTitle:(NSString *)title
                 message:(NSString *)message
              leftAction:(ClickAction)leftAction
             rightAction:(ClickAction)rightAction {
    [self showMAltertTitle:title
                   message:message
                 leftTitle:@"确定"
                rightTitle:@"取消"
                leftAction:leftAction
               rightAction:rightAction];
}

#pragma mark - tips
- (void)showTips:(NSString *)tips {
    [self showTips:tips onView:self.view];
}

- (void)showTips:(NSString *)tips onView:(UIView *)onView {
    [self showTips:tips onView:onView offsetTop:0];
}

- (void)showTips:(NSString *)tips onView:(UIView *)onView offsetTop:(CGFloat)top {
    if (!_tipsView) {
        _tipsView = [[ZLTipsView alloc] initWithFrame:onView.frame tips:tips];
        _tipsView.top = top;
        [onView addSubview:_tipsView];
    }
}

- (void)hideTips {
    _tipsView.hidden = YES;
    [_tipsView removeFromSuperview];
    _tipsView = nil;
}

#pragma mark - failed and reload
- (void)showFailedOnView:(UIView *)onView {
    if (!_failedView) {
        _failedView = [[ZLFailedAndReloadView alloc] initWithFrame:onView.frame];
        _failedView.delegate = self;
        [self.view addSubview:_failedView];
    } else {
        [_failedView didFinishLoading];
    }
}

- (void)showFaildView {
    if (!_failedView) {
        if (_navigationBar) {
            _failedView = [[ZLFailedAndReloadView alloc] initWithFrame:CGRectMake(0, NAVBARHEIGHT, self.view.width, self.view.height - NAVBARHEIGHT)];
            [self.view insertSubview:_failedView belowSubview:_navigationBar];
        } else {
            _failedView = [[ZLFailedAndReloadView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:_failedView];
        }
        _failedView.delegate = self;
    } else {
        [_failedView didFinishLoading];
    }
}

- (void)hideFailedView {
    [_failedView removeFromSuperview];
    _failedView = nil;
}

#pragma mark - show toast
- (void)showNotice:(NSString *)notice {
    [ShowToast showNotice:notice];
}

- (void)showNotice:(NSString *)notice duration:(NSTimeInterval)duration {
    [ShowToast showNotice:notice duraton:duration];
}

#pragma mark - message

@end
