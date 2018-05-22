//
//  NSString+ZLEX.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/5/12.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZLEX)

- (void)showNotice;

- (NSString *)trim;


/**
 计算 size

 @param font 字体大小
 @param width 限定宽度
 @return 计算所得 size
 */
- (CGSize)sizeWithUIFont:(UIFont *)font forWidth:(CGFloat)width;


/**
 计算 size

 @param attribute 富文本 属性
 @param width 限定宽度
 @return 计算所得 size
 */
- (CGSize)sizeWithUIAttribute:(NSDictionary *)attribute forWidth:(CGFloat)width;

- (CGSize)sizeWithSize:(CGSize)size font:(NSInteger)font;

- (BOOL)isNotEmptyString;

- (NSString *)urldecode;
- (NSString *)urlencode;

- (NSString *)md5;
- (NSString *)SHA256;

#pragma mark - bankcardformat
- (NSString *)formatBankCard;

/**
 * urlString add params
 **/
- (NSString *)addURLParamsFromDictionary:(NSDictionary *)params;

/**
 * isNewversion
 **/

#pragma mark - 判断程序是否是最新版本,从而判断是否需要进入引导界面
+ (BOOL)isNewVersion;


@end
