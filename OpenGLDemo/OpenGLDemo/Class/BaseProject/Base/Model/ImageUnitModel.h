//
//  ImageUnitModel.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/17.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一般图片的基本 属性
 */
@interface ImageUnitModel : NSObject

@property (nonatomic, strong) NSString *src; // url
@property (nonatomic, assign) CGFloat ar; // width / height
@property (nonatomic, assign) CGFloat w;  // width
@property (nonatomic, assign) CGFloat h;  // height
@property (nonatomic, strong) NSString *link; // link

@end
