//
//  ZLToastView.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLToastView : UIView

+ (void)showNotice:(NSString *)notice duration:(NSTimeInterval)timeInterval;
+ (void)showNotice:(NSString *)notice;

@end
