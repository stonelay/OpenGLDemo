//
//  BankCardModuleEntity.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "BankCardModuleEntity.h"
#import "VerifyBankCardController.h"
#import "VerifyBankCardListController.h"
#import "AddBankCardController.h"
#import "BankCardController.h"

@implementation BankCardModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static BankCardModuleEntity *moduleEntity = nil;
    dispatch_once(&onceToken, ^{
        moduleEntity = [[BankCardModuleEntity alloc] init];
    });
    return moduleEntity;
}

+ (void)load {
    NSArray *hosts = @[VerifyBankCardHost, VerifyBankCardListHost, AddBankCardHost, BankCardListHost];
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
    if ([url.host isEqualToString:VerifyBankCardHost]) {
        VerifyBankCardController *vc = [[VerifyBankCardController alloc] init];
        vc.bankCardId = urlParams[@"bankCardId"];
        vc.bankNumLast = urlParams[@"bankNumLast"];
        [navigationController pushViewController:vc animated:YES];
    }
    if ([url.host isEqualToString:VerifyBankCardListHost]) {
        VerifyBankCardListController *vc = [[VerifyBankCardListController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:AddBankCardHost]) {
        AddBankCardController *vc = [[AddBankCardController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:BankCardListHost]) {
        BankCardController *vc = [[BankCardController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    
}

@end
