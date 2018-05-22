//
//  ApplicationEntity.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/21.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ApplicationEntity.h"
#import "ZLTabbarController.h"

#import "MineController.h"
#import "LoanController.h"
#import "BorrowController.h"

#import "GeTuiSdk.h"

#import "ZLGuideController.h"
#import "BqsDeviceFingerPrinting.h"


@interface ApplicationEntity() <ZLTabBarControllerDelegate, BqsDeviceFingerPrintingDelegate, GeTuiSdkDelegate, BqsDeviceFingerPrintingContactsDelegate>

@end

@implementation ApplicationEntity

+ (instancetype)shareInstance {
    static ApplicationEntity *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ApplicationEntity alloc] init];
    });
    return instance;
}

#pragma mark - application system
- (void)applicationEntrance:(UIWindow *)mainWindow launchOptions:(NSDictionary *)launchOptions {
    [super applicationEntrance:mainWindow launchOptions:launchOptions];
    if ([NSString isNewVersion]) {
        [self showGuide];
    } else {
        [self addViewControllers];
    }
    
    [self initBQS];
}

- (void)applicationEnterForeground {
    [super applicationEnterForeground];
}

- (void)applicationActive {
    [super applicationActive];
}

- (void)applicationEnterBackground {
    [super applicationEnterBackground];
}

- (void)handleOpenURL:(NSString *)aUrl{
    [super handleOpenURL:aUrl];
}

- (void)applicationRegisterDeviceToken:(NSData*)deviceToken {
    [super applicationRegisterDeviceToken:deviceToken];
}

- (void)applicationFailToRegisterDeviceToken:(NSError*)error {
    [super applicationFailToRegisterDeviceToken:error];
}

- (void)applicationReceiveNotifaction:(NSDictionary*)userInfo {
    [super applicationReceiveNotifaction:userInfo];
}

- (BOOL)applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation { return YES; }

- (BOOL)applicationHandleOpenURL:(NSURL *)url { return YES; }

- (void)applicationPerformFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    
    [self didReceiveRemoteNotification:userInfo];
}

#pragma mark - custom
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo {
}

#pragma mark - init controllers
- (void)showGuide {
    ZLGuideController *guideController = [[ZLGuideController alloc] init];
    self.window.rootViewController = guideController;
    [self.window makeKeyAndVisible];
}

- (void)hideGuide {
    [self addViewControllers];
}

- (void)addViewControllers {
    
    self.tabbarController = [[ZLTabbarController alloc] initWithViewControllers:
                             @[
                               [[LoanController alloc] init],
                               [[BorrowController alloc] init],
                               [[MineController alloc] init]
                               ]];
    
    self.tabbarController.tabBarControllerDelegate = self;
    
    ZLNavigationController *navigationController = [[ZLNavigationController alloc] initWithRootViewController:self.tabbarController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    self.currentNavController = navigationController;
}

- (void)initBQS {
    [[BqsDeviceFingerPrinting sharedBqsDeviceFingerPrinting] setBqsDeviceFingerPrintingDelegate:self];
    [[BqsDeviceFingerPrinting sharedBqsDeviceFingerPrinting] setBqsDeviceFingerPrintingContactsDelegate:self];
    
    // TODO bqs params 需要更换
    NSDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"yrsd" forKey:@"partnerId"];
    [params setValue:@"YES" forKey:@"isGatherContacts"];
    [params setValue:@"YES" forKey:@"isGatherGps"];
    //    [params setValue:isEnvDev forKey:@"isEnvDev"];
    
    
    [[BqsDeviceFingerPrinting sharedBqsDeviceFingerPrinting] initBqsDFSdkWithParams:params];
    
    NSLog(@"getTokenKey=%@",[[BqsDeviceFingerPrinting sharedBqsDeviceFingerPrinting] getTokenKey]);
}

#pragma mark - BqsDeviceFingerPrintingDelegate
-(void)onBqsDFInitSuccess:(NSString *)tokenKey{
    NSLog(@"初始化成功 tokenKey=%@", tokenKey);
}

-(void)onBqsDFInitFailure:(NSString *)resultCode withDesc:(NSString *)resultDesc{
    NSLog(@"SDK初始化失败 resultCode=%@, resultDesc=%@", resultCode, resultDesc);
}

#pragma mark - BqsDeviceFingerPrintingContactsDelegate
-(void)onBqsDFContactsUploadSuccess:(NSString *)tokenKey{
    NSLog(@"通讯录上传成功 tokenKey=%@", tokenKey);
}

-(void)onBqsDFContactsUploadFailure:(NSString *)resultCode withDesc:(NSString *)resultDesc{
    NSLog(@"通讯录上传失败 resultCode=%@, resultDesc=%@", resultCode, resultDesc);
}

#pragma mark - tabbar delegate 
- (BOOL)tabBarController:(ZLTabbarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if ([viewController isKindOfClass:[BorrowController class]]) {
        [[ZLNavigationService sharedService] openUrl:LocalAppHost(OfferMoneyHost)];
        return NO;
    }
    if ([viewController isKindOfClass:[MineController class]]) {
        BOOL isLogin = [UserInfoService shareUserInfo].isLogin;
        if (!isLogin) {
            [[UserInfoService shareUserInfo] doLogin];
        }
        return isLogin;
    }
    return YES;
}

// 选中了
- (void)tabBarController:(ZLTabbarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index {}

//未选择 跳转
- (void)didSelectedInTabBarController {}
//以选中 再次选中
- (void)didSelectedInTabBarControllerDidAppeared {}




@end

