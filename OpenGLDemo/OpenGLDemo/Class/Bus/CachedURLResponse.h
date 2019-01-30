//
//  CachedURLResponse.h
//  OpenGLDemo
//
//  Created by Lay on 2019/1/29.
//  Copyright © 2019 Zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CachedURLResponse : NSObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * encoding;
@property (nonatomic, retain) NSData * data;

@end

NS_ASSUME_NONNULL_END
