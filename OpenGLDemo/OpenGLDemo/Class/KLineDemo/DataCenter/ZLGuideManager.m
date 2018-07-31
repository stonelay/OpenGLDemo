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
#import "ZLBOLLParam.h"

#import "ZLGuideModel.h"

#define BOLLDefaultPeriod 20.0
#define BOLLDefaultK 2.0

#define BOLLDefaultUpColor      ZLHEXCOLOR(0x800080)
#define BOLLDefaultMidColor     ZLHEXCOLOR(0x191970)
#define BOLLDefaultLowColor     ZLHEXCOLOR(0x98FB98)
#define BOLLDefaultBandColor    ZLHEXCOLOR_a(0xCD5C5C, 0.1)

#define MA1DefaultColor ZLHEXCOLOR(0xBA55D3)
#define MA2DefaultColor ZLHEXCOLOR(0xF8F8FF)
#define MA3DefaultColor ZLHEXCOLOR(0x00BFFF)
#define MA4DefaultColor ZLHEXCOLOR(0x3CB371)
#define MA5DefaultColor ZLHEXCOLOR(0xF0E68C)

@interface ZLGuideManager()

// ma
@property (nonatomic, strong) ZLMATransformer *maTransformer;
@property (nonatomic, strong) NSDictionary *maParamsDic; // <MAKey, params>
@property (nonatomic, strong) NSMutableDictionary *maGuideData; // <MAKey, datapack>

// boll
@property (nonatomic, strong) ZLBOLLTransformer *bollTransformer;
@property (nonatomic, strong) ZLBOLLParam *bollParam;
@property (nonatomic, strong) ZLGuideDataPack *bollDataPack;


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
    [self setDefaultBOLLParams];
}

#pragma mark - update
- (void)updateWithChartData:(NSArray *)chartData {
    [self updateMAChartData:chartData];
    [self updateBOLLChartData:chartData];
}

- (void)updateMAChartData:(NSArray *)chartData {
    for (NSString *key in [self.maParamsDic allKeys]) {
        ZLMAParam *maParam = [self.maParamsDic objectForKey:key];
        ZLGuideDataPack *pack = [self.maTransformer transToGuideData:chartData guideParam:maParam];
        [self.maGuideData setValue:pack forKey:key];
    }
}

- (void)updateBOLLChartData:(NSArray *)chartData {
    self.bollDataPack = [self.bollTransformer transToGuideData:chartData guideParam:self.bollParam];
}

#pragma mark - transformer
- (ZLMATransformer *)maTransformer {
    if (!_maTransformer) {
        _maTransformer = [[ZLMATransformer alloc] init];
    }
    return _maTransformer;
}

- (ZLBOLLTransformer *)bollTransformer {
    if (!_bollTransformer) {
        _bollTransformer = [[ZLBOLLTransformer alloc] init];
    }
    return _bollTransformer;
}

#pragma mark - default
- (void)setDefaultMAParams {
    NSDictionary *tDic = [[NSMutableDictionary alloc] init];
    
//    [tDic setValue:[self getMAParamWithColor:MA1DefaultColor period:5 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA1];
//    [tDic setValue:[self getMAParamWithColor:MA2DefaultColor period:10 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA2];
    [tDic setValue:[self getMAParamWithColor:MA3DefaultColor period:20 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA3];
//    [tDic setValue:[self getMAParamWithColor:MA4DefaultColor period:60 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA4];
//    [tDic setValue:[self getMAParamWithColor:MA5DefaultColor period:144 maDataType:ZLMADataTypeSMA] forKey:PKey_MADataID_MA5];
    
    self.maParamsDic = [tDic copy];
    self.maGuideData = [[NSMutableDictionary alloc] init];
}

- (void)setDefaultBOLLParams {
    ZLBOLLParam *param = [[ZLBOLLParam alloc] init];
    param.period = 20.0; // default
    param.k = 2.0;
    param.upColor = BOLLDefaultUpColor;
    param.midColor = BOLLDefaultMidColor;
    param.lowColor = BOLLDefaultLowColor;
    param.bandColor = BOLLDefaultBandColor;
    self.bollParam = param;
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
- (ZLGuideDataPack *)getMADataPackByKey:(NSString *)dataKey {
    return [self.maGuideData objectForKey:dataKey];
}

- (ZLGuideDataPack *)getBOLLDataPack {
    return self.bollDataPack;
}

- (SMaximum *)getMAMaximunWithRange:(NSRange)range {
    CGFloat min = FLT_MAX;
    CGFloat max = 0;
    for (NSString *key in [self.maGuideData allKeys]) {
        ZLGuideDataPack *dataPack = [self.maGuideData objectForKey:key];
        NSArray *dataArray = [dataPack.dataArray subarrayWithRange:range];
        for (ZLGuideModel *model in dataArray) {
            if (model.needDraw) {
                min = MIN(min, model.data);
                max = MAX(max, model.data);
            }
        }
    }
    return [SMaximum initWithMax:max min:min];
}

- (SMaximum *)getBOLLMaximunWithRange:(NSRange)range {
    CGFloat min = FLT_MAX;
    CGFloat max = 0;
    
    NSArray *dataArray = [self.bollDataPack.dataArray subarrayWithRange:range];
    for (ZLGuideModel *model in dataArray) {
        if (model.needDraw) {
            min = MIN(min, model.lowData);
            max = MAX(max, model.upData);
        }
    }
    return [SMaximum initWithMax:max min:min];
}
@end

@implementation SMaximum

+ (instancetype)initWithMax:(CGFloat)max min:(CGFloat)min {
    SMaximum *model = [[SMaximum alloc] init];
    model.max = max;
    model.min = min;
    return model;
}

@end
