//
//  InstItemModel.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/17.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageUnitModel.h"

@interface InstItemModel : NSObject

@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) ImageUnitModel *image;
@property (nonatomic, strong) NSString *extraDesc;

@end
