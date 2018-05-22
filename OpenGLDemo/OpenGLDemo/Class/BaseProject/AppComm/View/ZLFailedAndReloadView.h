//
//  ZLFailedAndReloadView.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLReloadDelegate;

@interface ZLFailedAndReloadView : UIView

@property (nonatomic, weak) id<ZLReloadDelegate> delegate;

- (void)didFinishLoading;

@end

@protocol ZLReloadDelegate <NSObject>

@optional
- (void)failedViewBeginReload:(ZLFailedAndReloadView *)reloadView;

@end
