//
//  ZLMutiTableViewCell.m
//  OpenGLDemo
//
//  Created by Lay on 2019/2/13.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import "ZLMutiTableViewCell.h"

@implementation ZLMutiTableViewCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView
{
    id cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:[self cellIdentifier]];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self initCellComponent];
    }
    return self;
}

- (void)initCellComponent
{
    
}

- (void)setCellData:(id)cellData
{
    _cellData = cellData;
    if (cellData) {
        [self reloadData];
    }
}

- (void)cellAddSubview:(UIView*)view
{
    [self.contentView addSubview:view];
}

- (void)reloadData
{
    
}

+ (NSNumber *)heightForCell:(id)cellData
{
    return 0;
}

@end
