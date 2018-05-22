//
//  MallModuleEntity.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/12.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "MallModuleEntity.h"

//#import "ConsigneeSelectController.h"
//#import "OrderPagerController.h"
//#import "CartController.h"
//#import "MyCollectionPagerController.h"
//#import "TMPointDetailController.h"
//#import "ShopInfoController.h"
//
//#import "MallItemController.h"
//
//#import "SiftCateController.h"

@implementation MallModuleEntity

+ (id)shareEntity {
    static dispatch_once_t onceToken;
    static MallModuleEntity *appModelEntity = nil;
    dispatch_once(&onceToken, ^{
        appModelEntity = [[MallModuleEntity alloc] init];
    });
    return appModelEntity;
}

+ (void)load {
    NSArray *hosts = @[MallOrderList, MallCart, MyCollection, PointDetail, MallItem, CateWall, MallShop];
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
//    if ([url.scheme isEqualToString:AppScheme]) {
//        if ([url.host isEqualToString:ConsigneeSelect]) {
//
//            ConsigneeSelectController *vc = [[ConsigneeSelectController alloc] init];
//            vc.consigneeId = urlParams[@"consigneeId"];
//            [urlParams removeObjectForKey:@"consigneeId"];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//
//        }
//        else if ([url.host isEqualToString:MallOrderList]) {
//            OrderPagerController *vc = [[OrderPagerController alloc] init];
//            vc.selectedIndex = [urlParams[@"index"] integerValue];
//            [urlParams removeObjectForKey:@"index"];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//
//        }
//        else if ([url.host isEqualToString:MallCart]) {
//            CartController *vc = [[CartController alloc] init];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//        else if ([url.host isEqualToString:MyCollection]) {
//            MyCollectionPagerController *vc = [[MyCollectionPagerController alloc] init];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//        else if ([url.host isEqualToString:PointDetail]) {
//            TMPointDetailController *vc = [[TMPointDetailController alloc] init];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//        else if ([url.host isEqualToString:MallItem]) {
//            MallItemController *vc = [[MallItemController alloc] init];
//            vc.itemId = urlParams[@"itemId"];
//            [urlParams removeObjectForKey:@"itemId"];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//        else if ([url.host isEqualToString:CateWall]) {
//            SiftCateController *vc = [[SiftCateController alloc] init];
//            vc.cateId = urlParams[@"cateId"];
//            [urlParams removeObjectForKey:@"cateId"];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//        else if ([url.host isEqualToString:MallShop]) {
//            ShopInfoController *vc = [[ShopInfoController alloc] init];
//            vc.shopId = urlParams[@"shopId"];
//            [urlParams removeObjectForKey:@"shopId"];
//            vc.extraParams = urlParams;
//            [navigationController pushViewController:vc animated:YES];
//        }
//    }
    
}

@end
