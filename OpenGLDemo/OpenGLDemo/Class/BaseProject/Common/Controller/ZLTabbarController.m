//
//  ZLTabbarController.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLTabbarController.h"

@interface ZLTabbarController ()

@end

@implementation ZLTabbarController

- (id)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        _childrenControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)reloadData{
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    for (BaseController *viewController in self.childrenControllers) {
        
        ZLTabbarItem *tabBarItem = viewController.tabbarItem;
        if (!tabBarItem) {
            tabBarItem = [[ZLTabbarItem alloc] initWithTitle:viewController.title
                                                  titleColor:ZLGray(51)
                                          selectedTitleColor:nil
                                                        icon:nil
                                                selectedIcon:nil];
            
            viewController.tabbarItem = tabBarItem;
        }
        [itemsArray addObject:tabBarItem];
        [self addChildViewController:viewController];
        viewController.tabBarController = self;
    }
    
    _selectIndex = 0;
    _selectedViewController = self.childrenControllers[0];
    [self.view addSubview:[self.childrenControllers[self.selectIndex] view]];
    
    _tabBar = [[ZLTabbar alloc] initWithFrame:CGRectMake(0, self.view.height - TABBARHEIGHT, self.view.width, TABBARHEIGHT) items:itemsArray delegate:self];
    [self.view addSubview:self.tabBar];
    
}


- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex > _childrenControllers.count - 1) {
        ZLWarningLog(@"超过 最大 索引");
        return;
    }
    
//    BaseController *vc = _childrenControllers[selectIndex];
    [_tabBar selectItemAtIndex:selectIndex];
}


#pragma mark tabbar delegate
- (void)tabBar:(ZLTabbar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (self.selectIndex == index) {
        // 已经选中的 再次选中
        if ([self.selectedViewController respondsToSelector:@selector(didSelectedInTabBarControllerDidAppeared)]) {
            [self.selectedViewController performSelector:@selector(didSelectedInTabBarControllerDidAppeared) withObject:nil];
        }
    } else {
        [self.selectedViewController.view removeFromSuperview];
        
        _selectIndex = index;
        _selectedViewController = self.childrenControllers[_selectIndex];
        
        [self.view insertSubview:self.selectedViewController.view belowSubview:self.tabBar];
        
        // tabBar 选中
        if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:didSelectViewController:atIndex:)]) {
            [self.tabBarControllerDelegate tabBarController:self didSelectViewController:self.selectedViewController atIndex:self.selectIndex];
        }
        
        // viewcontroller 选中 跳转
        if ([self.selectedViewController respondsToSelector:@selector(didSelectedInTabBarController)]) {
            [self.selectedViewController performSelector:@selector(didSelectedInTabBarController) withObject:nil];
        }
    }
}

- (BOOL)tabBar:(ZLTabbar *)zlTabbar couldSelectItemAtindex:(NSInteger)index {
    BOOL shouldSelect = YES;
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:atIndex:)]) {
        shouldSelect = [self.tabBarControllerDelegate tabBarController:self shouldSelectViewController:self.childrenControllers[index] atIndex:index];
    }
    
    return shouldSelect;
}


@end
