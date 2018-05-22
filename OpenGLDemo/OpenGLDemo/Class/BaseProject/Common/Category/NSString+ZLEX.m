//
//  NSString+ZLEX.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/5/12.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "NSString+ZLEX.h"
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

@implementation NSString (ZLEX)

- (void)showNotice{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                                                       message:self
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    
    
    [alertView show];
}

- (NSString *)trim {
    // 不需要判断self nil 的情况， 因为 对空对象发送消息 返回nil
    if([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isNotEmptyString {
    // 不需要判断self nil 的情况， 因为 空对象
    if ([self.trim isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (CGSize)sizeWithUIFont:(UIFont *)font forWidth:(CGFloat)width {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [self sizeWithUIAttribute:attribute forWidth:width];
    return size;
}

- (CGSize)sizeWithUIAttribute:(NSDictionary *)attribute forWidth:(CGFloat)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

- (CGSize)sizeWithSize:(CGSize)size font:(NSInteger)font {
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
}

- (NSString *)urldecode {
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlencode {
    static NSString * const kCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)kCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, kCFStringEncodingUTF8);
}


- (NSString *)md5{
    return [self getMd5_32Bit];
}

- (NSString *)SHA256 {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

- (NSString *)getMd5_32Bit {
    
    const char *newStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(newStr,(unsigned int)strlen(newStr),result);
    NSMutableString *outStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
        [outStr appendFormat:@"%02x",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
    }
    return outStr;
}

- (NSString *)addURLParamsFromDictionary:(NSDictionary *)params {
    NSMutableString *_add = nil;
    if (NSNotFound != [self rangeOfString:@"?"].location) {
        _add = [NSMutableString stringWithString:@"&"];
    }else {
        _add = [NSMutableString stringWithString:@"?"];
    }
    for (NSString* key in [params allKeys]) {
        NSString *value = [params objectForKey:key];
        if (value && [value isKindOfClass:[NSString class]] && 0 < [value length]) {
            [_add appendFormat:@"%@=%@&",[key urlencode],[value urlencode]];
        }
    }
    NSInteger position = self.length;
    NSRange range = [self rangeOfString:@"#"];
    if (range.length > 0) {
        position = range.location;
    }
    NSMutableString *string = [self mutableCopy];
    [string insertString:[_add substringToIndex:[_add length] - 1] atIndex:position];
    return string;
}

#pragma mark - bankcardformat
- (NSString *)formatBankCard {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    NSString *text = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text length] >= 21) {
    }
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    return newString;
}

#pragma mark - 判断程序是否是最新版本,从而判断是否需要进入引导界面
+ (BOOL)isNewVersion{
    
    //获取之前版本,与当前版本比较
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version_key"];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = dict[@"CFBundleShortVersionString"];
    
    if ([oldVersion isEqualToString:nowVersion]) {
        
        return NO;
        
    }else{
        
        //保存当前最新版本
        [[NSUserDefaults standardUserDefaults] setObject:nowVersion forKey:@"version_key"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        return YES;
    }
    
}

@end
