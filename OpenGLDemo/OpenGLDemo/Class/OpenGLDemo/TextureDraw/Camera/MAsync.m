//
//  MAsync.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/13.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "MAsync.h"

@interface MAsync()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

static void *queueKey = &queueKey;
void runAsync(void (^block)(void)) {
    dispatch_queue_t videoProcessingQueue = [[MAsync share] queue];
    //    if (dispatch_get_current_queue() == videoProcessingQueue)
    if (dispatch_get_specific(queueKey)) {
        block();
    } else {
        dispatch_async(videoProcessingQueue, block);
    }
}

@implementation MAsync

+ (instancetype)share {
    static MAsync *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[MAsync alloc] init];
    });
    return m;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.m.key", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0));
        dispatch_queue_set_specific(_queue, queueKey, (__bridge void *)self, NULL);
    }
    return self;
}



@end
