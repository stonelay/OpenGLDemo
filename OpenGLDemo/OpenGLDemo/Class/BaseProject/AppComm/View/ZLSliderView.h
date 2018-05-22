//
//  ZLSliderView.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPageCountView.h"
#import "SwipeView.h"

typedef NS_ENUM(NSInteger, SliderViewPageControlStyle){
    SliderViewPageControlStylePoint,
    SliderViewPageControlStyleNumber,
};

typedef NS_ENUM(NSInteger, SliderViewPageControlAlignment){
    SliderViewPageControlAlignmentLeft      = 0,
    SliderViewPageControlAlignmentCenter    = 1,
    SliderViewPageControlAlignmentRight     = 2,
};


@protocol ZLSliderViewDelegate, ZLSliderViewDataSource;

@interface ZLSliderView : UIView



@property(nonatomic, weak) id <ZLSliderViewDelegate> delegate;
@property(nonatomic, weak) id <ZLSliderViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(SliderViewPageControlStyle)style
                    alignment:(SliderViewPageControlAlignment)alignment;
- (instancetype)initWithStyle:(SliderViewPageControlStyle)style
                    alignment:(SliderViewPageControlAlignment)alignment;

@property(nonatomic, readonly) NSInteger totalItemCount;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) BOOL wrapEnabled;
@property(nonatomic, assign) BOOL autoScroll;
@property (nonatomic, strong) UIColor *currentPageColor;
@property(nonatomic) BOOL disableScrollOnlyOneImage;

- (void)reloadData;
- (void)scrollToItemAtIndex:(NSInteger)index;
- (void)jumpToItemAtIndex:(NSInteger)index;

@end

@protocol ZLSliderViewDelegate <NSObject>
@optional
- (void)sliderView:(ZLSliderView *)sliderView didSelectViewAtIndex:(NSInteger)index;
- (void)sliderView:(ZLSliderView *)sliderView didSliderToIndex:(NSInteger)index;
- (void)sliderViewDidScroll:(ZLSliderView *)sliderView;
- (void)sliderViewWillBeginDragging:(ZLSliderView *)sliderView;
- (void)sliderViewDidEndDragging:(ZLSliderView *)sliderView willDecelerate:(BOOL)decelerate;
- (void)sliderViewWillBeginDecelerating:(ZLSliderView *)sliderView;
- (void)sliderViewDidEndDecelerating:(ZLSliderView *)sliderView;
- (void)sliderViewDidEndScrollingAnimation:(ZLSliderView *)sliderView;

@end

@protocol ZLSliderViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSliderView:(ZLSliderView *)sliderView;
- (UIView *)sliderView:(ZLSliderView *)sliderView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;
@end

