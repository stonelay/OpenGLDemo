//
//  InstModel.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/17.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "InstModel.h"

@implementation InstModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [InstItemModel class]};
}
@end
