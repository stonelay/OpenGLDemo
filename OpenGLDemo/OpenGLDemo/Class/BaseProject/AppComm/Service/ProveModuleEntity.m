//
//  ProveModuleEntity.m
//  Jietiao
//
//  Created by LayZhang on 2018/3/23.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ProveModuleEntity.h"

#import "IDProveController.h"
#import "OperationProveController.h"
#import "RelationProveController.h"
#import "RecogIDController.h"
#import "ShowIDController.h"

#import "MoxieSDK.h"

@implementation ProveModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static ProveModuleEntity *moduleEntity = nil;
    dispatch_once(&onceToken, ^{
        moduleEntity = [[ProveModuleEntity alloc] init];
    });
    return moduleEntity;
}

+ (void)load {
    NSArray *hosts = @[IDProveHost, RelationProveHost, OperationHost,
                       IDRecoHost, ShowIDHost, HighProve];
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
    if ([url.host isEqualToString:IDProveHost]) {
        IDProveController *vc = [[IDProveController alloc] init];
        vc.notice = urlParams[@"notice"];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:OperationHost]) {
        [navigationController popToRootViewControllerAnimated:NO];
        OperationProveController *vc = [[OperationProveController alloc] init];
        vc.notice = urlParams[@"notice"];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:RelationProveHost]) {
        [navigationController popToRootViewControllerAnimated:NO];
        RelationProveController *vc = [[RelationProveController alloc] init];
        vc.notice = urlParams[@"notice"];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:IDRecoHost]) {
        RecogIDController *vc = [[RecogIDController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:ShowIDHost]) {
        [navigationController popToRootViewControllerAnimated:NO];
        ShowIDController *vc = [[ShowIDController alloc] init];
        vc.model = urlParams;
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:HighProve]) {
        [MoxieSDK shared].taskType = urlParams[@"taskType"];
        [[MoxieSDK shared] start];
    }
}

@end
