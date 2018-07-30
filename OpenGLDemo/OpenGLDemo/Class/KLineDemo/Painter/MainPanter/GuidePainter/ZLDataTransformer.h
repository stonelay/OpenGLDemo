//
//  ZLDataTransformer.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/30.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLGuideDataPack.h"
#import "ZLGuideParam.h"

static NSString *const kGUIDE_ID_MA     = @"MA";
static NSString *const kGUIDE_ID_BOLL   = @"BOLL";
static NSString *const kGUIDE_ID_RSI    = @"RSI";
static NSString *const kGUIDE_ID_KDJ    = @"KDJ";
static NSString *const kGUIDE_ID_MACD   = @"MACD";

@interface ZLDataTransformer : NSObject

- (NSString *)guideID;

- (ZLGuideDataPack *)transToGuideData:(NSArray *)chartDataArray
                           guideParam:(ZLGuideParam *)guideParam;


@end
