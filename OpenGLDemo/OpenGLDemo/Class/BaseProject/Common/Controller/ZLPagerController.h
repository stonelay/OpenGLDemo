//
//  ZLPagerController.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/12.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseController.h"

@protocol ZLPagerDelegate;

@interface ZLTabView : UIView

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@interface ZLPagerController : BaseController

@property (nonatomic, weak) id<ZLPagerDelegate> delegate;
@property (nonatomic, assign) BOOL noScroll;
@property (nonatomic, assign) BOOL noSelectBold;
@property (nonatomic, assign) BOOL hideNavigationBar;
@property (nonatomic, assign) BOOL hideTab;
@property (nonatomic, strong) UIColor *choosedColor;

@property (nonatomic, strong) NSArray *tabNames;

- (void)reloadData;
- (void)reloadContents;
- (void)selectTabAtIndex:(NSUInteger)index;

@end


@protocol ZLPagerDelegate <NSObject>

- (NSUInteger)numberOfTabsForViewPager:(ZLPagerController *)viewPager;
//- (UILabel *)viewPager:(ZLPagerController *)viewPager tabForTabAtIndex:(NSUInteger)index;
- (void)viewPager:(ZLPagerController *)viewPager tabForTabAtIndex:(NSUInteger)index tabView:(ZLTabView *)tabView;
- (CGFloat)tabBarWdith;

@optional

- (UIViewController *)viewPager:(ZLPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (UIView *)viewPager:(ZLPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;
- (void)viewPager:(ZLPagerController *)viewPager didSelectTabAtIndex:(NSInteger)index;
@end
