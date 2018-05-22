//
//  LoanModuleEntity.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "LoanModuleEntity.h"
#import "RecoverController.h"
#import "RepayController.h"
#import "NeedRepayDetailController.h"
#import "NeedRecoverDetailController.h"

#import "AlreadyRepayDetailController.h"
#import "AlreadyRecoverDetailController.h"

#import "LoanDetailController.h"

#import "PublishingLoanController.h"
#import "OtherPublishController.h"
#import "PublishingListController.h"
#import "LoanSuccessController.h"

#import "RiskReportController.h"

@implementation LoanModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static LoanModuleEntity *moduleEntity = nil;
    dispatch_once(&onceToken, ^{
        moduleEntity = [[LoanModuleEntity alloc] init];
    });
    return moduleEntity;
}

+ (void)load {
    NSArray *hosts = @[RepayHost, RecoverHost,
                       NeedRepayDetailHost, NeedRecoverDetailHost,
                       AlreadyRepayDetailHost, AlreadyRecoverDetailHost,
                       LoanDetailHost,
                       PublishingHost, OtherPublishingHost, PublishingListHost,
                       LoanSuccessHost, RiskReportHost];
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
    if ([url.host isEqualToString:RecoverHost]) {
        RecoverController *vc = [[RecoverController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:RepayHost]) {
        RepayController *vc = [[RepayController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:NeedRecoverDetailHost]) {
        NeedRecoverDetailController *vc = [[NeedRecoverDetailController alloc] init];
        vc.id = urlParams[@"id"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:NeedRepayDetailHost]) {
        NeedRepayDetailController *vc = [[NeedRepayDetailController alloc] init];
        vc.id = urlParams[@"id"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:AlreadyRecoverDetailHost]) {
        AlreadyRecoverDetailController *vc = [[AlreadyRecoverDetailController alloc] init];
        vc.id = urlParams[@"id"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:AlreadyRepayDetailHost]) {
        AlreadyRepayDetailController *vc = [[AlreadyRepayDetailController alloc] init];
        vc.id = urlParams[@"id"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:LoanDetailHost]) {
        LoanDetailController *vc = [[LoanDetailController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:OtherPublishingHost]) {
        OtherPublishController *vc = [[OtherPublishController alloc] init];
        vc.id = urlParams[@"id"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:PublishingHost]) {
        PublishingLoanController *vc = [[PublishingLoanController alloc] init];
        vc.id = urlParams[@"id"];
        vc.status = [urlParams[@"status"] integerValue];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:PublishingListHost]) {
        PublishingListController *vc = [[PublishingListController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:LoanSuccessHost]) {
        LoanSuccessController *vc = [[LoanSuccessController alloc] init];
        vc.payId = urlParams[@"payId"];
        [navigationController pushViewController:vc animated:YES];
    } else if ([url.host isEqualToString:RiskReportHost]) {
        RiskReportController *vc = [[RiskReportController alloc] init];
        vc.url = urlParams[@"url"];
        vc.isBuy = [urlParams[@"isBuy"] integerValue];
        [navigationController pushViewController:vc animated:YES];
    }
    
}

@end
