//
//  ZLTabbarController.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseController.h"
#import "ZLTabbar.h"

@protocol ZLTabBarControllerDelegate;

@interface ZLTabbarController : BaseController<ZLTabbarDelegate>

@property(nonatomic, strong, readonly) ZLTabbar *tabBar;


@property(nonatomic, strong, readonly) NSArray *childrenControllers; // children controllers
@property (nonatomic, strong, readonly) NSArray *defaultViewControllers;
@property(nonatomic, strong, readonly) BaseController *selectedViewController;
@property(nonatomic, assign) NSInteger selectIndex;

@property(nonatomic, weak) id<ZLTabBarControllerDelegate> tabBarControllerDelegate;

- (id)initWithViewControllers:(NSArray *)viewControllers;

//- (void)selectAtIndex:(NSInteger)index;
- (void)reloadData;

@end

@protocol ZLTabBarControllerDelegate <NSObject>

@optional
// 能否选中
- (BOOL)tabBarController:(ZLTabbarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

// 选中了
- (void)tabBarController:(ZLTabbarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

//未选择 跳转
- (void)didSelectedInTabBarController;
//以选中 再次选中
- (void)didSelectedInTabBarControllerDidAppeared;

@end


