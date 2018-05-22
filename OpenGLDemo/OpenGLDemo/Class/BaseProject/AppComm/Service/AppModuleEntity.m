//
//  AppModuleEntity.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/21.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "AppModuleEntity.h"
#import "ZLNavigationService.h"
#import "ApplicationEntity.h"

#import "LoginController.h"
#import "RegistController.h"
#import "ForgotPwdController.h"

#import "TradePwdSetController.h"
#import "TradePwdModifyController.h"
#import "TradePwdModifyByBankCardController.h"

#import "MainController.h"

#import "RiskReportListController.h"
#import "SettingController.h"
#import "AboutUsController.h"
#import "FeedbackController.h"
#import "FeedbackListController.h"


//#import "ProblemController.h"
//#import "FeedBackController.h"
//#import "FeedbackListController.h"
//#import "MessageController.h"
//#import "MessageDetailController.h"
//#import "SettingController.h"
//#import "VisitedController.h"
//#import "AboutusController.h"
//#import "QRCodeController.h"
//#import "LoanDetailController.h"
//#import "BecomeMemberController.h"
//#import "SettingController.h"
//#import "TMChangeNickController.h"
//#import "TMChangeGenderController.h"

@implementation AppModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static AppModuleEntity *appModelEntity = nil;
    dispatch_once(&onceToken, ^{
        appModelEntity = [[AppModuleEntity alloc] init];
    });
    return appModelEntity;
}

+ (void)load {
    NSArray *hosts = @[PopCtrlHost, PopRootCtrlHost, LoginHost, RegistHost, ForgotPwdHost,
                       TradePwdSetHost, MainHost,TradePwdModifyHost, TradePwdModifyByBCHost,
                       RiskReportListHost, SettingHost, AbountUsHost, FeedBackHost, FeedBackListHost];
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
    if ([url.host isEqualToString:LoginHost]) {
        [[UserInfoService shareUserInfo] clearData];
        [[ApplicationEntity shareInstance].tabbarController setSelectIndex:0];
        
        UIViewController *topVC = navigationController.topViewController;
        if ([topVC isKindOfClass:[LoginController class]]) {
            return;
        }
        if([navigationController.childViewControllers count] > 1){
            [navigationController popToRootViewControllerAnimated:NO];
        }
        LoginController *vc = [[LoginController alloc] init];
        [navigationController pushViewController:vc animated:NO];
    }
    else if ([url.host isEqualToString:PopCtrlHost]) {
        [navigationController popViewControllerAnimated:YES];
    }
    else if ([url.host isEqualToString:PopRootCtrlHost]) {
        [navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url.host isEqualToString:RegistHost]) {
//        UIViewController *topVC = navigationController.topViewController;
//        if ([topVC isKindOfClass:[RegistController class]]) {
//            return;
//        }
//        if([navigationController.childViewControllers count] > 1){
//            [navigationController popToRootViewControllerAnimated:NO];
//        }
        
        RegistController *vc = [[RegistController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:ForgotPwdHost]) {
        ForgotPwdController *vc = [[ForgotPwdController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:TradePwdModifyHost]) {
        TradePwdModifyController *vc = [[TradePwdModifyController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:TradePwdModifyByBCHost]) {
        while ([navigationController.childViewControllers count] > 2) {
            [navigationController popViewControllerAnimated:NO];
        }
        TradePwdModifyByBankCardController *vc = [[TradePwdModifyByBankCardController alloc] init];
        vc.busId = urlParams[@"busId"];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:TradePwdSetHost]) {
        TradePwdSetController *vc = [[TradePwdSetController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:MainHost]) {
        MainController *vc = [[MainController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:SettingHost]) {
        SettingController *vc = [[SettingController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:RiskReportListHost]) {
        RiskReportListController *vc = [[RiskReportListController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:AbountUsHost]) {
        AboutUsController *vc = [[AboutUsController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:FeedBackHost]) {
        FeedbackController *vc = [[FeedbackController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    else if ([url.host isEqualToString:FeedBackListHost]) {
        FeedbackListController *vc = [[FeedbackListController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }

   
    
    
//    else if ([url.host isEqualToString:ProblemHost]) {
//        ProblemController *vc = [[ProblemController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    }

//    else if ([url.host isEqualToString:FeedBackListHost]) {
//        FeedbackListController *vc = [[FeedbackListController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    }
//    else if ([url.host isEqualToString:MessageHost]) {
//        MessageController *vc = [[MessageController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    }
//    else if ([url.host isEqualToString:MessageDetailHost]) {
//        MessageDetailController *vc = [[MessageDetailController alloc] init];
//        vc.model = userInfo[@"data"];
//        [navigationController pushViewController:vc animated:YES];
//    }
//    else if ([url.host isEqualToString:VisitedHost]) {
//        VisitedController *vc = [[VisitedController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    }

//    else if ([url.host isEqualToString:QRCodeHost]) {
//        QRCodeController *vc = [[QRCodeController alloc] init];
//        [navigationController pushViewController:vc animated:YES];
//    }
//    else if ([url.host isEqualToString:LoanHost]) {
//        ZLTabbarController *tabbarcontroller = [[ApplicationEntity shareInstance] tabbarController];
//        [tabbarcontroller.tabBar selectItemAtIndex:1];
//    }
//    else if ([url.host isEqualToString:HomeHost]) {
//        ZLTabbarController *tabbarcontroller = [[ApplicationEntity shareInstance] tabbarController];
//        [tabbarcontroller.tabBar selectItemAtIndex:0];
//    }
//    else if ([url.host isEqualToString:MineHost]) {
//        ZLTabbarController *tabbarcontroller = [[ApplicationEntity shareInstance] tabbarController];
//        [tabbarcontroller.tabBar selectItemAtIndex:2];
//    }
    
    
    
}
@end
