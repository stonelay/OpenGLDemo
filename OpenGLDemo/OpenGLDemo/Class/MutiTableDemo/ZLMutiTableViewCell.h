//
//  ZLMutiTableViewCell.h
//  OpenGLDemo
//
//  Created by Lay on 2019/2/13.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLMutiTableViewCell : UITableViewCell

@property (nonatomic, strong) id cellData;

+ (NSString *)cellIdentifier;
+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView;

- (void)cellAddSubview:(UIView*)view;

#pragma mark - public func
- (void)reloadData;
+ (NSNumber *)heightForCell:(id)cellData;
- (void)initCellComponent;

@end

NS_ASSUME_NONNULL_END
