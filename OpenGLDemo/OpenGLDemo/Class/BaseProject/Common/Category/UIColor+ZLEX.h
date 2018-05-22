//
//  UIColor+ZLEX.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZLEX)


/**
 *  根据十六进制字符串生成 UIColor
 *
 *  @param hexString  十六进制颜色值
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  根据十六进制字符串生成 UIColor
 *
 *  @param hexString  十六进制颜色值
 *  @param alpha  透明度
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
