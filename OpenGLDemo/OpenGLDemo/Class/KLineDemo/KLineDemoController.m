//
//  KLineDemoController.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/17.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "KLineDemoController.h"

#import "ZLPaintView.h"

#import "KLineModel.h"
#import "ZLQuoteDataCenter.h"

@interface KLineDemoController ()<NSXMLParserDelegate>

@end

@implementation KLineDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBarWithTitle:self.controllerTitle withLeft:[UIImage imageNamed:@"icon_back"]];
    
    ZLPaintView *painter = [[ZLPaintView alloc] initWithFrame:CGRectMake(10, NAVBARHEIGHT + 10, SCREENWIDTH - 2 * 10, SCREENHEIGHT - NAVBARHEIGHT - 2 * 10)];
    painter.linePainterOp = ZLKLinePainterOpGride | ZLKLinePainterOpCandle | ZLKLinePainterOpBOLL;
//    ZLKLinePainterOpMA;
    [painter draw];
//
//    ZLGridePainter *painter1 = [[ZLGridePainter alloc] initWithFrame:CGRectMake(20, NAVBARHEIGHT + 20, SCREENWIDTH - 2 * 10, SCREENHEIGHT - NAVBARHEIGHT - 2 * 10)];
//    [painter1 zl_draw];
    
    [self.view addSubview:painter];
//    [self.view addSubview:painter1];
    
    
//    NSArray *a = [ZLQuoteDataCenter shareInstance].hisKLineData;
}


- (NSString *)controllerTitle {
    return @"KLine";
}

@end
