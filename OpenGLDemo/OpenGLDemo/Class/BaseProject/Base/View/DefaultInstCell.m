//
//  DefaultInstCell.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/26.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "DefaultInstCell.h"

@interface DefaultInstCell()

@property (nonatomic, strong) UILabel *defaultLabel;

@end

@implementation DefaultInstCell

#pragma mark - override
- (void)reloadData {
//    self.backgroundColor = ZLGray(200);
    self.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.defaultLabel];
    
    self.defaultLabel.text = @"default cell";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _defaultLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 100);
}

+ (NSNumber *)heightForCell:(id)cellData {
    return @(100);
}

#pragma mark - property
- (UILabel *)defaultLabel {
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.backgroundColor = [UIColor redColor];
    }
    return _defaultLabel;
}

@end
