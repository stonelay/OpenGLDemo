//
//  main.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/1/18.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "avformat.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        av_register_all();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
