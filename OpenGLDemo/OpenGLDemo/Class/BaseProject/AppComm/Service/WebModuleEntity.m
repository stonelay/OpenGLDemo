//
//  WebModuleEntity.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/11.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "WebModuleEntity.h"

#import "BaseWebController.h"

@implementation WebModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static WebModuleEntity *moduleEntity = nil;
    dispatch_once(&onceToken, ^{
        moduleEntity = [[WebModuleEntity alloc] init];
    });
    return moduleEntity;
}

+ (void)load {
    [[ZLNavigationService sharedService] registerModule:self withScheme:@"http" host:nil];
    [[ZLNavigationService sharedService] registerModule:self withScheme:@"https" host:nil];
    //webview
    [[ZLNavigationService sharedService] registerModule:self withScheme:AppScheme host:@"web"];
    
}

- (void)handleOpenUrl:(NSString *)urlString userInfo:(NSDictionary *)userInfo from:(id)from complete:(void (^)(void))complete {
    ZLNavigationController *navigationController = [[ApplicationEntity shareInstance] currentNavigationController];
    
    NSString *strUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableDictionary *urlParams = [[url parameters] mutableCopy];
    
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        
        BaseWebController *vc = [[BaseWebController alloc] init];
        vc.url = urlString;
        vc.shareTitle = userInfo[@"title"];
        [navigationController pushViewController:vc animated:YES];
        
    } else if( [url.scheme isEqualToString:AppScheme] ){
        
        if([url.host isEqualToString:@"web"]) {
            
            BaseWebController *vc = [[BaseWebController alloc] init];

            vc.url = [urlParams[@"url"] urldecode];
            vc.shareUrl = urlParams[@"shareUrl"];
            vc.shareDesc = urlParams[@"shareDesc"];
            vc.shareImage = urlParams[@"shareImage"];
            vc.shareTitle = urlParams[@"shareTitle"];

            [navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    
}

@end
