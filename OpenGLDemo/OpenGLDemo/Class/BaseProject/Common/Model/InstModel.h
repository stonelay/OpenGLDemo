//
//  InstModel.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/17.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstItemModel.h"

@interface InstModel : NSObject

@property (nonatomic, strong) NSArray<InstItemModel *> *list;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) NSString *wp;

@end
