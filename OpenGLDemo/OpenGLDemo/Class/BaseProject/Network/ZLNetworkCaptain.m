//
//  ZLNetworkCaptain.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLNetworkCaptain.h"

#import "ZLNavigationService.h"

#ifdef DEBUG

//#define BaseURLString @"http://dadi.zhixunkeji.cn"


//#define BaseURLString @"http://supermarket.xunzhuji.cn/" // zhengshi
//#define BaseURLString @"http://10.60.10.103/"  // mock
#define BaseURLString @"http://10.60.10.114:8768" // ceshi
//#define BaseURLString @"http://10.60.50.43:8768" // yuanyuan

//#define BaseURLString @"http://10.60.50.41:8768" // feixiang

//#define BaseURLString @"http://10.60.50.41:8080"  // feixiang
#define TimeOutInterval 0

//#define H5WebUrl @"http://139.196.210.150:12345/riskReport.html?userId=";

#else

//#define BaseURLString @"http://dadi.zhixunkeji.cn"
//#define BaseURLString @"http://10.60.50.41:8080"
//#define BaseURLString @"http://10.60.10.103/"  // mock

#define BaseURLString @"http://10.60.10.114:8768" // ceshi
//#define H5WebUrl @"http://139.196.210.150:12345/riskReport.html?userId=";
#define TimeOutInterval 0

#endif

@implementation ZLNetworkCaptain

+ (instancetype)sharedInstance {
    static ZLNetworkCaptain *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        instance = [[ZLNetworkCaptain alloc] initWithBaseURL:baseURL];
        if (TimeOutInterval > 0) {
            instance.requestSerializer.timeoutInterval = TimeOutInterval;
        }
        instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
    });
    return instance;
}

#pragma mark - request
- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(StatusModel *))failure {
    [self getWithUrl:URLString
          parameters:parameters
            progress:nil
             success:success
             failure:failure];
}

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(StatusModel *))failure {
    [self postWithUrl:URLString
           parameters:parameters
             progress:nil
              success:success
              failure:failure];
}

#pragma mark - base request
- (void)getWithUrl:(NSString *)URLString
        parameters:(NSDictionary *)parameters
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSDictionary *result))success
           failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addAppParams:parameters];
    [self addHeadFields:parameters];
    ZLLog(@"GET URL:%@",URLString);
    ZLLog(@"Parameters:%@",parameters);
    NSURLSessionDataTask *task =
    [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        ZLLog(@"downloadProgress:%@", downloadProgress);
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];
    ZLLog(@"Full path:%@",task.originalRequest.URL);
}

- (void)postWithUrl:(NSString *)URLString
         parameters:(NSDictionary *)parameters
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(NSDictionary *result))success
            failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addAppParams:parameters];
    [self addHeadFields:parameters];
    ZLLog(@"POST URL:%@",URLString);
    ZLLog(@"Parameters:%@",parameters);
    
    NSURLSessionDataTask *task =
    [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        ZLLog(@"downloadProgress:%@", downloadProgress);
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];
    ZLLog(@"Full path:%@",task.originalRequest.URL);
}

#pragma mark - upload data 
- (void)postFormDataWithUrl:(NSString *)URLString
                 parameters:(NSDictionary *)parameters
  constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBlock
                   progress:(void (^)(NSProgress *))progress
                    success:(void (^)(NSDictionary *result))success
                    failure:(void (^)(StatusModel *status))failure {
    
    parameters = [self addAppParams:parameters];
    [self addHeadFields:parameters];
    ZLLog(@"POST URL:%@",URLString);
    ZLLog(@"Parameters:%@",parameters);
    NSURLSessionDataTask *task =
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (constructingBlock) {
            constructingBlock(formData);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        ZLLog(@"downloadProgress:%@", uploadProgress);
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ( success && failure ) {
            [self requestSuccess:success failure:failure data:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [self requestFailure:failure data:error];
        }
        
    }];
    ZLLog(@"Full path:%@",task.originalRequest.URL);
}

- (void)postImageWithUrl:(NSString *)URLString
                   image:(id)imageData
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(StatusModel *))failure {
    [self postImageWithUrl:URLString
                     image:imageData
                parameters:parameters
                  progress:nil
                   success:success
                   failure:failure];
}

- (void)postImageWithUrl:(NSString *)URLString
                   image:(id)imageData
              parameters:(NSDictionary *)parameters
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(NSDictionary *result))success
                 failure:(void (^)(StatusModel *status))failure {
    
    // 支持 iOS8 later
    parameters = [self addAppParams:parameters];
    [self addHeadFields:parameters];
    ZLLog(@"POST URL:%@",URLString);
    ZLLog(@"Parameters:%@",parameters);
    
    [self postFormDataWithUrl:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([imageData isKindOfClass:[UIImage class]]) {
            
            NSData *image = UIImageJPEGRepresentation(imageData, 1);
            [formData appendPartWithFileData:image
                                        name:@"image"
                                    fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
        
        if ([imageData isKindOfClass:[NSArray class]]) {
            NSArray *imageArray = imageData;
            for (int i = 0; i < imageArray.count; i++) {
                NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1);
                [formData appendPartWithFileData:imageData
                                            name:@"image[]"//[NSString stringWithFormat:@"image%d",index]
                                        fileName:[NSString stringWithFormat:@"image%d.jpg",i]
                                        mimeType:@"image/jpeg"];

            }
        }
    } progress:^(NSProgress *uploadProgress) {
        ZLLog(@"upload Progress:%@", uploadProgress);
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSDictionary *result) {
        if (success) {
            success(result);
        }
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

#pragma mark - deal with response object
- (void)requestSuccess:(void (^)(NSDictionary *result))success failure:(void (^)(StatusModel *status))failure data:(id) data {
    NSLog(@"print response data : %@", data);
    NSDictionary *responseDictionary = [data copy];
    ResponseModel *responseModel = [ResponseModel yy_modelWithDictionary:responseDictionary];
    
    // 解析获得 返回数据， 可根据不同项目 做不同解析
    
    if (responseModel && StatusCodeSuccess == responseModel.status){
        if (success) {
            success(responseModel.data);
        }
    } else {
        if (responseModel && StatusCodeUnlogin == responseModel.status) {
            [[ZLNavigationService sharedService] openUrl:SConnect(AppSchemeCompeled, LoginHost)];
            return;
        }
        
        if (failure) {
            if (!responseModel) {
                StatusModel *status = [[StatusModel alloc] init];
                
                status.status = StatusCodeFailed;
                status.message = @"网络异常";
                
                failure(status);
            } else {
                failure(responseModel);
            }
        }
    }
}

- (void)requestFailure:(void (^)(StatusModel *status))failure data:(NSError *)error {
    StatusModel *status = [[StatusModel alloc] init];
    status.status = error.code;
    status.message = @"网络异常";
    ZLLog(@"net err message : %@", error.userInfo.description);
    failure(status);
}


#pragma mark - do before send request
- (NSDictionary *)addAppParams:(NSDictionary *)params {
    NSMutableDictionary *appParams = [NSMutableDictionary dictionary];
    
    // you can add app normal params here
    
    if (params) {
        [appParams addEntriesFromDictionary:params];
    }
    
    if ([UserInfoService shareUserInfo].isLogin) {
        appParams[@"sign"] = [UserInfoService shareUserInfo].userInfo.sign;
    }
    
    appParams[@"platform"] = @"ios";
    appParams[@"versionName"] = [UIApplication sharedExtensionApplication].appVersion;
    appParams[@"did"] = [UIDevice uniqueID];
    
    return appParams;
}

- (void)addHeadFields:(NSDictionary *)params {
    // you can add headField params here
    
//     [self.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    if ([UserInfoService shareUserInfo].isLogin) {
        NSString *userToken = [UserInfoService shareUserInfo].userInfo.userToken;
        if ([userToken isNotEmptyString]) {
            [self.requestSerializer setValue:@"Authorization" forHTTPHeaderField:userToken];
        }
    }
}



@end
