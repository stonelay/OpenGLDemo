//
//  ZLNetworkCaptain.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <AFHTTPSessionManager.h>
#import "ResponseModel.h"

@interface ZLNetworkCaptain : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
           success:(void (^)(NSDictionary *result))success
           failure:(void (^)(StatusModel *status))failure;

- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSDictionary *result))success
           failure:(void (^)(StatusModel *status))failure;

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *result))success
            failure:(void (^)(StatusModel *status))failure;

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(NSDictionary *result))success
            failure:(void (^)(StatusModel *status))failure;


#pragma mark - image upload
- (void)postImageWithUrl:(NSString *)URLString
                   image:(id)imageData
              parameters:(NSDictionary *)parameters
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(StatusModel *status))failure;


- (void)postImageWithUrl:(NSString *)URLString
                   image:(id)imageData
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(StatusModel *status))failure;

@end
