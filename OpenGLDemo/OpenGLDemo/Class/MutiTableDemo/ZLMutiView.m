//
//  ZLMutiView.m
//  OpenGLDemo
//
//  Created by Lay on 2019/2/12.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import "ZLMutiView.h"

static const CGFloat   defaultTopBarHeight     = 38.0f;
static const CGFloat   defaultCellHeight       = 28.0f;

@interface ZLMutiView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentTopView;
@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) UIView *leftTopView;
@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation ZLMutiView

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Accessor
- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.bounces = NO;
        _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.bounces = NO;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
//    if (tableView == self.contentTableView) {
//        cell = [self updateContentTableViewCellWithIndex:indexPath];
//    }
//
//    if (tableView == self.leftTableView) {
//        cell = [self updateLeftTableViewCellWithIndex:indexPath];
//    }
//
//    if (!tableView) {
//        NSLog(@"*** get unknown err tableview !!! ***");
//    }
    
    return cell;
    
    //    NSLog(@"*** get unknown err tableview !!! ***");
    //    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
