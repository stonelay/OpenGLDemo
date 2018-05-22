//
//  AttachModuleEntity.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "AttachModuleEntity.h"

#import "CouponController.h"
#import "CouponSelectController.h"
#import "CouponHisController.h"
#import "UrgeController.h"
#import "MessageController.h"
#import "MessageDetailController.h"
#import "ReviewHisController.h"
#import "FavController.h"

@implementation AttachModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static AttachModuleEntity *moduleEntity = nil;
    dispatch_once(&onceToken, ^{
        moduleEntity = [[AttachModuleEntity alloc] init];
    });
    return moduleEntity;
}

+ (void)load {
    NSArray *hosts = @[CouponHost, CouponSelectHost, CouponHisHost, UrgeHost,
                       MessageHost, MessageDetailHost,
                       ReviewHisHost, FavHost];
    for (NSString *host in hosts) {
        [[ZLNavigationService sharedService] registerModule:self
                                                 withScheme:AppScheme
                                                       host:host];
    }
}

- (BOOL)canOpenUrl:(NSString *)urlString userInfo:(NSDictionary *)userInfo from:(id)from {
    return YES;
}

- (void)handleOpenUrl:(NSString *)urlString userInfo:(NSDictionary *)userInfo from:(id)from complete:(void(^)(void))complete {
    ZLNavigationController *navigationController = [[ApplicationEntity shareInstance] currentNavigationController];
    
    NSString *strUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableDictionary *urlParams = [[url parameters] mutableCopy];
    if ([url.host isEqualToString:CouponHost]) {
        CouponController *vc = [[CouponController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:CouponHisHost]) {
        CouponHisController *vc = [[CouponHisController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:UrgeHost]) {
        UrgeController *vc = [[UrgeController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:MessageDetailHost]) {
        MessageDetailController *vc = [[MessageDetailController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:MessageHost]) {
        MessageController *vc = [[MessageController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:ReviewHisHost]) {
        ReviewHisController *vc = [[ReviewHisController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:FavHost]) {
        FavController *vc = [[FavController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:CouponSelectHost]) {
        CouponSelectController *vc = [[CouponSelectController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
}
@end
