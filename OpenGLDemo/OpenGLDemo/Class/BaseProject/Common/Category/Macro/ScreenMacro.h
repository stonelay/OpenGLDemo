//
//  ScreenMacro.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#ifndef ScreenMacro_h
#define ScreenMacro_h

#import "ShowToast.h"


/** screen util**/
#pragma mark - screen
#define Screen [UIScreen mainScreen]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENBOUNDS [UIScreen mainScreen].bounds
#define SCREENSCALE [UIScreen mainScreen].scale
#define LINEWIDTH   1.f / [UIScreen mainScreen].scale
#define STATUSBARHEIGHT             20.f
#define NAVBARCONTAINERHEIGHT       44.f
#define NAVBARHEIGHT                (NAVBARCONTAINERHEIGHT + STATUSBARHEIGHT)
#define TABBARHEIGHT                49

#define TABSVIEWHEIGHT             44

/** color **/
#pragma mark - color
#define ZLWhiteColor    [UIColor whiteColor]
#define ZLClearColor    [UIColor clearColor]
#define ZLBlackColor    [UIColor blackColor]
#define ZLRedColor      [UIColor redColor]
#define ZLNoticeColor   ZLHEXCOLOR(0xF95E49)

#define ZLRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ZLRGB(r,g,b)    ZLRGBA(r,g,b,1)
#define ZLGray(g)       ZLRGB(g,g,g)

#define ZLHEXA(hex,a)       [UIColor colorWithHexString:hex alpha:a]
#define ZLHEX(hex)          ZLHEXA(hex,1)

#define ZLHEXCOLOR_a(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:(a)]
#define ZLHEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

/** font **/
#pragma mark - font
#define ZLBoldFont(x)   [UIFont boldSystemFontOfSize:(x)]
#define ZLNormalFont(x) [UIFont systemFontOfSize:(x)]
#define ZLItalicFont(x) [UIFont italicSystemFontOfSize:(x)]
#define ZLDINFont(x)    [UIFont fontWithName:@"DINNextW1G-Medium" size:(x)]

#pragma mark - scale
#define SCALE (SCREENWIDTH/375.0)

#endif /* ScreenMacro_h */
