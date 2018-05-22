//
//  ItemMarkView.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLMyBaseView.h"

@protocol ItemMarkViewDelegate;

@interface ItemMarkView : ZLMyBaseView

@property (nonatomic, assign) CGFloat mark;          // 分数
@property (nonatomic, assign) CGFloat markWidth;    // 星星的 大小
@property (nonatomic, assign) CGFloat labelFont;    // 分数字体
@property (nonatomic, assign) BOOL showMark;        // 是否显示分数

@property (nonatomic, weak) id<ItemMarkViewDelegate> delegate;

@end

@protocol ItemMarkViewDelegate <NSObject>

- (void)changeMarkValue:(ItemMarkView *)itemMarkView;

@end
