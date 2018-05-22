//
//  ApplicationEntity.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/21.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseApplicationEntity.h"


// appdelegate 分担

@interface ApplicationEntity : BaseApplicationEntity

+ (instancetype)shareInstance;

- (void)showGuide;
- (void)hideGuide;

@end
