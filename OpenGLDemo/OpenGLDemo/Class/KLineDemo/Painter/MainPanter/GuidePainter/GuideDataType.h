//
//  GuideDataType.h
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/31.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#ifndef GuideDataType_h
#define GuideDataType_h


static NSString *const kGUIDE_ID_MA     = @"MA";
static NSString *const kGUIDE_ID_BOLL   = @"BOLL";
static NSString *const kGUIDE_ID_RSI    = @"RSI";
static NSString *const kGUIDE_ID_KDJ    = @"KDJ";
static NSString *const kGUIDE_ID_MACD   = @"MACD";

typedef NS_ENUM(int, ZLGuideDataName) {
    ZLMADataName      = 0,
    ZLMADataName_SMA     ,
    ZLMADataName_EMA     ,
    ZLMADataName_WMA     ,
    
    ZLBOLLDataName       ,
    ZLBOLLDataName_UP    ,
    ZLBOLLDataName_MID   ,
    ZLBOLLDataName_LOW   ,
    
    //    ZLKDJDataName        ,
    //    ZLKDJDataName_KLine  ,
    //    ZLKDJDataName_DLine  ,
    //    ZLKDJDataName_JLine  ,
    //
    //    ZLMACDDataName       ,
    //    ZLMACDDataName_DIF   ,
    //    ZLMACDDataName_DEA   ,
    //    ZLMACDDataName_MACD  ,
    //
    //    ZLRSIDataName        ,
    //    ZLRSIDataName_Long   ,
    //    ZLRSIDataName_Short  ,
};

#endif /* GuideDataType_h */
