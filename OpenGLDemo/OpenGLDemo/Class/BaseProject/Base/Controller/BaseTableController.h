//
//  BaseTableController.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ScrollableController.h"

@interface BaseTableController : ScrollableController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;

- (void)checkEmptyWithMessage:(NSString *)message andEmptyImage:(NSString *)image;
- (void)reloadData;

- (void)couldScrollToFooter:(BOOL)couldScrollToFooter;

#pragma mark - empty
- (void)showEmpty:(NSString *)notice image:(NSString *)image;
- (void)hideEmpty;

@end
