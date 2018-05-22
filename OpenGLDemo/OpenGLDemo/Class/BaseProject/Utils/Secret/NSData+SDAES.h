//
//  NSData+SDAES.h
//  SD
//
//  Created by LayZhang on 2017/6/28.
//  Copyright © 2017年 ZXKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SDAES)
- (NSData *)AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;   //解密

@end
