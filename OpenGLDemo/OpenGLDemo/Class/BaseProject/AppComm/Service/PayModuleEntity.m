//
//  PayModuleEntity.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/19.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "PayModuleEntity.h"
#import "ZLNavigationService.h"
#import "ApplicationEntity.h"

//#import "YueController.h"
//#import "WithdrawController.h"
//#import "PaymentsController.h"
//#import "RechargeController.h"
//#import "RSController.h"
//#import "WSController.h"
//#import "OrderDetailsController.h"
//#import "OfferMoneyController.h"
//#import "CouponController.h"
//#import "RepaySuccessController.h"

@implementation PayModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static PayModuleEntity *appModelEntity = nil;
    dispatch_once(&onceToken, ^{
        appModelEntity = [[PayModuleEntity alloc] init];
    });
    return appModelEntity;
}

+ (void)load {
    NSArray *hosts = @[yueHost, RechargeHost, WithdrawHost, PaymentsHost,
                       RechargeSuccessHost, WithdrawSuccessHost, OrderDetailHost,
                       OfferMoneyHost, RepaySuccessHost];
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
//    if ([url.host isEqualToString:yueHost]) {
//        YueController *vc = [[YueController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:RechargeHost]) {
//        RechargeController *vc = [[RechargeController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:WithdrawHost]) {
//        WithdrawController *vc = [[WithdrawController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:PaymentsHost]) {
//        PaymentsController *vc = [[PaymentsController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:RechargeSuccessHost]) {
//        RSController *vc = [[RSController alloc] init];
//        vc.amount = urlParams[@"amount"];
//        vc.bankInfo = urlParams[@"bankInfo"];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:WithdrawSuccessHost]) {
//        WSController *vc = [[WSController alloc] init];
//        vc.amount = urlParams[@"amount"];
//        vc.bankInfo = urlParams[@"bankInfo"];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:OrderDetailHost]) {
//        OrderDetailsController *vc = [[OrderDetailsController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:OfferMoneyHost]) {
//        OfferMoneyController *vc = [[OfferMoneyController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    } else if([url.host isEqualToString:RepaySuccessHost]) {
//        RepaySuccessController *vc = [[RepaySuccessController alloc] init];
//        vc.payId = urlParams[@"payId"];
//        [navigationController pushViewController:vc animated:YES];
//    }
    
}
@end
