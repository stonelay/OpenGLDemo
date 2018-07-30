//
//  ZLGuideManager.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/27.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGuideManager.h"

#import "ZLMATransformer.h"
#import "ZLBOLLTransformer.h"

#import "ZLMAParam.h"

#define MA1DefaultColor ZLHEXCOLOR(0xBA55D3)
#define MA2DefaultColor ZLHEXCOLOR(0xF8F8FF)
#define MA3DefaultColor ZLHEXCOLOR(0x00BFFF)
#define MA4DefaultColor ZLHEXCOLOR(0x3CB371)
#define MA5DefaultColor ZLHEXCOLOR(0xF0E68C)

@interface ZLGuideManager()

@property (nonatomic, strong) ZLMATransformer *maTransformer;
@property (nonatomic, strong) NSDictionary *maParamsDic; // <MAKey, params>
@property (nonatomic, strong) NSMutableDictionary *maGuideData; // <MAKey, datapack>

@end

@implementation ZLGuideManager

- (instancetype)init {
    if (self = [super init]) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault {
    [self setDefaultMAParams];
}

#pragma mark - update
- (void)updateWithChartData:(NSArray *)chartData {
    [self updateMAChartData:chartData];
}

- (void)updateMAChartData:(NSArray *)chartData {
    for (NSString *key in [self.maParamsDic allKeys]) {
        ZLMAParam *maParam = [self.maParamsDic objectForKey:key];
        ZLGuideDataPack *pack = [self.maTransformer transToGuideData:chartData guideParam:maParam];
        [self.maGuideData setValue:pack forKey:key];
    }
}

#pragma mark - transformer
- (ZLMATransformer *)maTransformer {
    if (!_maTransformer) {
        _maTransformer = [[ZLMATransformer alloc] init];
    }
    return _maTransformer;
}

#pragma mark - default
- (void)setDefaultMAParams {
    NSDictionary *tDic = [[NSMutableDictionary alloc] init];
    
    [tDic setValue:[self getMAParamWithColor:MA1DefaultColor period:5 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA1];
    [tDic setValue:[self getMAParamWithColor:MA2DefaultColor period:10 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA2];
    [tDic setValue:[self getMAParamWithColor:MA3DefaultColor period:30 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA3];
    [tDic setValue:[self getMAParamWithColor:MA4DefaultColor period:60 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA4];
    [tDic setValue:[self getMAParamWithColor:MA5DefaultColor period:144 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA5];
    
    self.maParamsDic = [tDic copy];
    self.maGuideData = [[NSMutableDictionary alloc] init];
}

#pragma mark - maker
- (ZLMAParam *)getMAParamWithColor:(UIColor *)color period:(NSInteger)period maDataType:(ZLMADataType)dataType {
    ZLMAParam *param = [[ZLMAParam alloc] init];
    param.maDataType = ZLMADataTypeSMA;
    param.period = period;
    param.maColor = color;
    return param;
}

#pragma mark - public
- (ZLGuideDataPack *)getDataPackByMAKey:(NSString *)dataKey {
    return [self.maGuideData objectForKey:dataKey];
}

@end
