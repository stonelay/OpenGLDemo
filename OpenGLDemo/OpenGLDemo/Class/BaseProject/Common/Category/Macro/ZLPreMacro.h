//
//  ZLPreMacro.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/5/8.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#ifndef ZLPreMacro_h
#define ZLPreMacro_h

#pragma mark - TEST

#define TESTPROVE_TYPE ProveTypeFaceId

/** import category or other third part **/
#pragma mark - import file
// extention
#import "UIView+ZLEX.h"
#import "UIView+QuickNew.h"
#import "UIImage+ZLEX.h"
#import "UIImageView+ZLEX.h"
#import "CALayer+ZLEX.h"
#import "UIButton+ZLEX.h"
#import "NSString+ZLEX.h"
#import "UIColor+ZLEX.h"
#import "NSURL+ZLEX.h"
#import "NSDate+ZLEX.h"

#import "NSObject+Runtime.h"
#import "UIApplication+YYAdd.h"

#import "UIDevice+ZLEX.h"

#import "BaseNullCheck.h"

// util
#import "Masonry.h"
#import "YYModel.h"
#import "ZLToastView.h"
#import "DateFormat.h"
#import "DecimalUtil.h"

/** log **/
#pragma mark - log
#ifdef DEBUG
#define ZLLog(...) NSLog(__VA_ARGS__)
#define ZLAllLog(format, ...) \
NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d] Log:" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define ZLFileLog(format, ...) \
NSLog((@"[文件名:%s] Log:" format), __FILE__, ##__VA_ARGS__);
#define ZLFuncLog(format, ...) \
NSLog((@"[函数名:%s] Log:" format), __FUNCTION__, ##__VA_ARGS__);
#define ZLFuncLineLog(format, ...) \
NSLog((@"[函数名:%s]" "[行号:%d] Log:" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);

#define ZLWarningLog(format, ...) \
NSLog((@"[文件名:%s] Warning Log:" format), __FILE__, ##__VA_ARGS__);
#define ZLErrorLog(format, ...) \
NSLog((@"[文件名:%s] Error Log:" format), __FILE__, ##__VA_ARGS__);

#else
#define ZLLog(...);
#define ZLAllLog(...);
#define ZLFileLog(...);
#define ZLFuncLog(...);
#define ZLFuncLineLog(...);

#define ZLErrorLog(...);
#define ZLWarningLog(...);
#endif

#define LogGRect(rect)       ZLLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define LogGSize(size)       ZLLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define LogGPoint(point)     ZLLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)


#endif /* ZLPreMacro_h */
