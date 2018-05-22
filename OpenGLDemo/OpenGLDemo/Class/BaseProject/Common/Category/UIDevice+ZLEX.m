//
//  UIDevice+ZLEX.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/10.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "UIDevice+ZLEX.h"
#import "NSString+ZLEX.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation UIDevice (ZLEX)

+ (NSString *)deviceName {
    static NSString *deviceName = nil;
    
    if (!deviceName) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *name = malloc(size);
        sysctlbyname("hw.machine", name, &size, NULL, 0);
        
        deviceName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        free(name);
        
        if( [@"i386" isEqualToString:deviceName] || [@"x86_64" isEqualToString:deviceName] ) {
            deviceName = @"iOS_Simulator";
        }
    }
    
    return deviceName;
}

+ (NSString *)uniqueID {
    static NSString *kUniqueIDKey = @"unique_key";
    NSString *uniqueId = @"";
    
    if (NSClassFromString(@"ASIdentifierManager")) {
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            uniqueId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
    
    if (!uniqueId) {//不存在说明用户关闭了广告跟踪
        uniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:kUniqueIDKey];
        if (!uniqueId) {
            NSString *timeString = [NSString stringWithFormat:@"%.5f",[[NSDate date] timeIntervalSince1970]];
            NSString *randomString = [NSString stringWithFormat:@"%d", arc4random() % 10000/*0-9999*/];
            
            uniqueId = [[timeString stringByAppendingString:randomString] md5];
            
            [[NSUserDefaults standardUserDefaults] setObject:uniqueId forKey:kUniqueIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return uniqueId;
}

@end
