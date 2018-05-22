//
//  BaseTableController.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseTableController.h"
#import "MJRefresh.h"
#import "BaseTableCell.h"

@interface BaseTableController ()

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation BaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentTableView];
    [self addRefreshAction];
    [self showNavigationBar];
}

- (void)addContentTableView {
    [self.view addSubview:self.contentTableView];
}

#pragma mark - property
- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    return _contentArray;
}

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        CGFloat top = self.isHideNavigationBar ? 0 : NAVBARHEIGHT;
        CGRect tableRect = CGRectMake(0, top, self.view.width, self.view.height - top);
        _contentTableView = [[UITableView alloc] initWithFrame:tableRect
                                                         style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = ZLClearColor;
    }
    return _contentTableView;
}

- (void)addRefreshAction {
    
    weakSelf(self);
    if (self.scrollViewRefreshType & ScrollViewRefreshTypeHeader) {
        self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(self);
            [self willRefresh];
        }];
    }
    
    if (self.scrollViewRefreshType & ScrollViewRefreshTypeFooter) {
        self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            strongSelf(self);
            [self willLoadMore];
        }];
    }
}

- (void)couldScrollToFooter:(BOOL)couldScrollToFooter {
    BOOL isAddFooter = (self.scrollViewRefreshType & ScrollViewRefreshTypeFooter) == ScrollViewRefreshTypeFooter;
    if (!isAddFooter) {
        return;
    }
    if (couldScrollToFooter) {
        if (!self.contentTableView.mj_footer) {
            weakSelf(self);
            self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                strongSelf(self);
                [self willLoadMore];
            }];
        }
    } else {
        if (self.contentTableView.mj_footer) {
            self.contentTableView.mj_footer = nil;
        }
    }
}

- (void)reloadData{
    if (self.contentTableView) {
        [self.contentTableView reloadData];
    }
}

- (void)willRefresh {
    [super willRefresh];
}

- (void)doRefresh {
    [super doRefresh];
}

- (void)didRefresh {
    [super didRefresh];
    [self.contentTableView.mj_header endRefreshing];
}

- (void)willLoadMore {
    [super willLoadMore];
}

- (void)doLoadMore {
    [super doLoadMore];
}

- (void)didLoadMore {
    [super didLoadMore];
    [self.contentTableView.mj_footer endRefreshing];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableCell *cell = [BaseTableCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - emptyView
- (void)checkEmptyWithMessage:(NSString *)message andEmptyImage:(NSString *)image {
    if ([self.contentArray count] == 0) {
        [self showEmpty:message image:image];
    } else {
        [self hideEmpty];
    }
}

- (void)showEmpty:(NSString *)notice image:(NSString *)image {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.backgroundColor = ZLWhiteColor;
        CGFloat navibar = 64;
        if (self.isHideNavigationBar) {
            navibar = 0;
        }
        _emptyView.frame = self.contentTableView.bounds;
//        CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - navibar);
        UIImageView *empty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        [empty sizeToFit];
        empty.centerX = SCREENWIDTH / 2;
        empty.top = 80 * SCALE;
        [_emptyView addSubview:empty];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = notice;
        label.textColor = ZLHEXCOLOR(0x999999);
        label.font = ZLNormalFont(14 * SCALE);
        [label sizeToFit];
        label.centerX = SCREENWIDTH / 2;
        label.top = empty.bottom + 5 * SCALE;
        [_emptyView addSubview:label];
    }
    [self.contentTableView addSubview:_emptyView];
}

- (void)hideEmpty {
    [self.emptyView removeFromSuperview];
}

@end
