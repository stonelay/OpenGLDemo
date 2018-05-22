//
//  UtilMacro.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/8.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#ifndef UtilMacro_h
#define UtilMacro_h

//#import "SafeObjectMacro.h"
#import "BlocksKit.h"
#import "UIActionSheet+BlocksKit.h"
#import "UIAlertView+BlocksKit.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UIControl+BlocksKit.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "UIPopoverController+BlocksKit.h"
#import "UITextField+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import "UIWebView+BlocksKit.h"
#import "UITextField+BlocksKit.h"
#import "UIImagePickerController+BlocksKit.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"

// button delay
#define DelayEnableButton(s, t) UIButton *enableButton = (UIButton *)s;\
enableButton.enabled = NO;\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
enableButton.enabled = YES;\
});

// request
#define MockHead @""
//#define MockHead @"/mockjsdata/6"

#define POST_REQUEST_BEGIN(_url_, _params_) \
NSString *url = [NSString stringWithFormat:@"%@%@", MockHead, (_url_)]; \
[[ZLNetworkCaptain sharedInstance] postWithUrl:(url) parameters:_params_ \
success:^(id result) { \
NSLog(@"%@", result);

#define GET_REQUEST_BEGIN(_url_, _params_) \
NSString *url = [NSString stringWithFormat:@"%@%@", MockHead, (_url_)]; \
[[ZLNetworkCaptain sharedInstance] getWithUrl:(url) parameters:_params_ \
success:^(id result) { \
NSLog(@"%@", result);

#define REQUEST_END(_model_) \
if (success) { success(_model_); } \
} failure:^(StatusModel *status) { \
if (failure) { failure(status); } }];

#define REQUEST_MUTABLE_END(_model1_, _model2_) \
if (success) { success(_model1_, _model2_); } \
} failure:^(StatusModel *status) { \
if (failure) { failure(status); } }];

//weakSelf & strongSelf
#define weakSelf( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__attribute__((objc_ownership(weak))) __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define strongSelf( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__attribute__((objc_ownership(strong))) __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#endif /* UtilMacro_h */
