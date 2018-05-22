//
//  ShowToast.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowToast : UIView

+ (void)showNotice:(NSString *)notice;
+ (void)showNotice:(NSString *)notice duraton:(NSTimeInterval)duration;

@end
