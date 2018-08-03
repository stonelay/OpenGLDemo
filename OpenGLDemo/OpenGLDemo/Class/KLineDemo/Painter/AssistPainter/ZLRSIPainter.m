//
//  ZLRSIPainter.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/8/3.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLRSIPainter.h"

@implementation ZLRSIPainter


//NSString * const RSIDataID_LongID   = @"RSILong";
//NSString * const RSIDataID_ShortID  = @"RSIShort";
//
//NSString * const PKey_Period_Long   = @"LongPeriod";
//NSString * const PKey_Period_Short  = @"ShortPeriod";
//
//
//@implementation DataTransForRSI
//
////--------------------------------------------------------------------------------------------------
//-(NSString *)       getGuideId
//{
//    return GUIDE_ID_RSI;
//}
//
////--------------------------------------------------------------------------------------------------
//-(GuideDataPack *)  transToGuideData:(NSArray *) chartDataArray guideParam:(GuideParam *) guideParam
//{
//    if(chartDataArray == nil || guideParam == nil || chartDataArray.count == 0){
//        return nil;
//    }
//
//    int lPeriod = (int)[guideParam getParamByKey:PKey_Period_Long];
//    int sPeriod = (int)[guideParam getParamByKey:PKey_Period_Short];
//
//    if(lPeriod < 1 || lPeriod >= chartDataArray.count){
//        return nil;
//    }
//
//    if(sPeriod < 1 || sPeriod >= chartDataArray.count){
//        return nil;
//    }
//
//    GuideDataPack * dataPack = [[GuideDataPack alloc] initWithGuideParam:guideParam];
//
//    NSMutableArray * longArray = [self transToLongGuideData:chartDataArray guideParam:guideParam];
//    NSMutableArray * shortArray = [self transToShortGuideData:chartDataArray guideParam:guideParam];
//
//    [dataPack setGuideData:longArray forGuideId:RSIDataID_LongID];
//    [dataPack setGuideData:shortArray forGuideId:RSIDataID_ShortID];
//
//    return dataPack;
//}
//
////--------------------------------------------------------------------------------------------------
//-(NSMutableArray *)  transToLongGuideData:(NSArray *) chartDataArray guideParam:(GuideParam *) guideParam
//{
//    NSMutableArray * longArray = [[NSMutableArray alloc] init];
//    int lPeriod = (int)[guideParam getParamByKey:PKey_Period_Long];
//
//    double maMax = 0.0;
//    double maAbs = 0.0;
//    double diff = 0.0;
//    double rsiValue = 0.0;
//    double closePrice1 = 0.0;
//    double closePrice2 = 0.0;
//
//    ChartDataNode * node = [chartDataArray lastObject];
//    closePrice1 = node.closePrice;
//
//    int sIdx = chartDataArray.count - 2;
//    int eIdx = chartDataArray.count - 2 - lPeriod + 1;
//
//    for(int i=sIdx; i>=eIdx; i--)
//    {
//        node = [chartDataArray objectAtIndex:i];
//        closePrice2 = closePrice1;
//        closePrice1 = node.closePrice;
//
//        diff = closePrice1 - closePrice2;
//        maAbs += ABS(diff);
//
//        diff = MAX(0.0, diff);
//        maMax += diff;
//    }
//
//    maAbs /= lPeriod;
//    maMax /= lPeriod;
//    rsiValue = (maMax / maAbs) * 100.0;
//
//    GuideData * data = [[GuideData alloc] initWithId:RSIDataID_LongID];
//    data.name = [GuideDataType getNameByDataType:JGDTRSIDataName_Long];
//    data.cycle = lPeriod;
//    data.data = rsiValue;
//    [longArray addObject:data];
//    //[longArray insertObject:data atIndex:0];
//
//    sIdx = chartDataArray.count - 2 - lPeriod;
//
//    for(int i=sIdx; i>=0; i--)
//    {
//        node = [chartDataArray objectAtIndex:i];
//        closePrice2 = closePrice1;
//        closePrice1 = node.closePrice;
//        diff = closePrice1 - closePrice2;
//
//        maAbs = (ABS(diff) + (double)(lPeriod - 1) * maAbs) / (double)lPeriod;
//        diff = MAX(0.0, diff);
//        maMax = (diff + (double) (lPeriod - 1) * maMax) / (double)lPeriod;
//        rsiValue = (maMax / maAbs) * 100.0;
//
//        data = [[GuideData alloc] initWithId:RSIDataID_LongID];
//        data.name = [GuideDataType getNameByDataType:JGDTRSIDataName_Long];
//        data.cycle = lPeriod;
//        data.data = rsiValue;
//        [longArray addObject:data];
//        //[longArray insertObject:data atIndex:0];
//    }
//
//    return longArray;
//}
//
////--------------------------------------------------------------------------------------------------
//-(NSMutableArray *)  transToShortGuideData:(NSArray *) chartDataArray guideParam:(GuideParam *) guideParam
//{
//    NSMutableArray * shortArray = [[NSMutableArray alloc] init];
//    int sPeriod = (int)[guideParam getParamByKey:PKey_Period_Short];
//
//    //
//    // short
//    //
//    float maMax = 0.0F;
//    float maAbs = 0.0F;
//    float diff = 0.0F;
//    float rsiValue = 0.0F;
//    float closePrice1 = 0.0F;
//    float closePrice2 = 0.0F;
//
//    ChartDataNode * node = [chartDataArray lastObject];
//    closePrice1 = node.closePrice;
//
//    int sIdx = chartDataArray.count - 2;
//    int eIdx = chartDataArray.count - 2 - sPeriod + 1;
//
//    for(int i=sIdx; i>=eIdx; i--)
//    {
//        node = [chartDataArray objectAtIndex:i];
//        closePrice2 = closePrice1;
//        closePrice1 = node.closePrice;
//
//        diff = closePrice1 - closePrice2;
//        maAbs += ABS(diff);
//
//        diff = MAX(0.0, diff);
//        maMax += diff;
//    }
//
//    maAbs /= sPeriod;
//    maMax /= sPeriod;
//    rsiValue = (maMax / maAbs) * 100.0;
//
//    GuideData * data = [[GuideData alloc] initWithId:RSIDataID_ShortID];
//    data.name = [GuideDataType getNameByDataType:JGDTRSIDataName_Short];
//    data.cycle = sPeriod;
//    data.data = rsiValue;
//    [shortArray addObject:data];
//    //[shortArray insertObject:data atIndex:0];
//
//    sIdx = chartDataArray.count - 2 - sPeriod;
//
//    for (int i=sIdx; i>=0; i--)
//    {
//        node = [chartDataArray objectAtIndex:i];
//        closePrice2 = closePrice1;
//        closePrice1 = node.closePrice;
//        diff = closePrice1 - closePrice2;
//
//        maAbs = (ABS(diff) + (double)(sPeriod - 1) * maAbs) / (double)sPeriod;
//        diff = MAX(0.0, diff);
//
//        maMax = (diff + (double)(sPeriod - 1) * maMax) / (double) sPeriod;
//        rsiValue = (maMax / maAbs) * 100.0;
//
//        data = [[GuideData alloc] initWithId:RSIDataID_ShortID];
//        data.name = [GuideDataType getNameByDataType:JGDTRSIDataName_Short];
//        data.cycle = sPeriod;
//        data.data = rsiValue;
//        [shortArray addObject:data];
//        //[shortArray insertObject:data atIndex:0];
//    }
//
//    return shortArray;
//}
@end
