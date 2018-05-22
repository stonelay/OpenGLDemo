//
//  NSURL+ZLEX.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "NSURL+ZLEX.h"

static void *kURLParametersDictionaryKey;
@implementation NSURL (ZLEX)

- (void)scanParameters {
    
    if (self.isFileURL) {
        return;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString: self.absoluteString];
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString:@"&?"] ];
    //skip to ?
    [scanner scanUpToString:@"?" intoString: nil];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *tmpValue;
    while ([scanner scanUpToString:@"&" intoString:&tmpValue]) {
        
        NSArray *components = [tmpValue componentsSeparatedByString:@"="];
        
        if (components.count >= 2) {
            NSString *key = [[components[0] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding] urldecode];
            NSString *value = [[components[1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding] urldecode];
            
            parameters[key] = value;
        }
    }
    
    self.parameters = parameters;
}

- (id)objectForKeyedSubscript:(id)key {
    
    return self.parameters[key];
}


- (NSString *)parameterForKey:(NSString *)key {
    
    return self.parameters[key];
}

- (NSDictionary *)parameters {
    
    NSDictionary *result = objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
    
    if (!result) {
        [self scanParameters];
    }
    
    return objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
}

- (void)setParameters:(NSDictionary *)parameters {
    
    objc_setAssociatedObject(self, &kURLParametersDictionaryKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

+ (NSURL *)queryWithBase:(NSString *)base queryElements:(NSDictionary *)queryElements {
    NSMutableArray<NSURLQueryItem *> *mQueryItems = [NSMutableArray array];
    for (NSString *key in queryElements) {
        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:queryElements[key]];
        [mQueryItems addObject:queryItem];
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:base] resolvingAgainstBaseURL:NO];
    components.queryItems = [mQueryItems copy];
    
    return components.URL;
}

@end
