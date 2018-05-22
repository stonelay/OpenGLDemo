//
//  ZLSliderView.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/27.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLSliderView.h"
#import "MWeakProxy.h"

@interface ZLSliderView()<SwipeViewDelegate, SwipeViewDataSource>

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) SliderViewPageControlStyle style; // number or point
@property(nonatomic, assign) SliderViewPageControlAlignment alignment; // left center or right

@property(nonatomic, strong) UIPageControl *pageControlPoint; // point
@property(nonatomic, strong) ZLPageCountView *pageControlNum; // number
@property(nonatomic, strong) SwipeView *swipeView;

@end

static const CGFloat SliderBannerChangeInterval = 4.0f;     // animation interval
static const CGFloat SliderAutoScrollDuration = 0.4;        // animation duration

@implementation ZLSliderView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(SliderViewPageControlStyle)style
                    alignment:(SliderViewPageControlAlignment)alignment {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.alignment = alignment;
        [self initComponent];
    }
    return self;
}

- (instancetype)initWithStyle:(SliderViewPageControlStyle)style
                    alignment:(SliderViewPageControlAlignment)alignment {
    if (self = [super init]) {
        self.style = style;
        self.alignment = alignment;
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    [self addSubview:self.swipeView];
    
    if (self.style == SliderViewPageControlStylePoint) {
        [self addSubview:self.pageControlPoint];
    } else if (self.style == SliderViewPageControlStyleNumber) {
        [self addSubview:self.pageControlNum];
    }
}

#pragma mark - properties
- (SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc] init];
        _swipeView.backgroundColor = [UIColor clearColor];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
        _swipeView.pagingEnabled = YES;
    }
    return _swipeView;
}

- (ZLPageCountView *)pageControlNum {
    if (!_pageControlNum) {
        _pageControlNum = [[ZLPageCountView alloc] initWithPageNumber:0];
        
    }
    return _pageControlNum;
}

- (UIPageControl *)pageControlPoint {
    if (!_pageControlPoint) {
        _pageControlPoint = [[UIPageControl alloc] init];
        _pageControlPoint.bottom = self.height - 3;
        _pageControlPoint.hidesForSinglePage = YES;
        _pageControlPoint.userInteractionEnabled = NO;
        _pageControlPoint.currentPageIndicatorTintColor = ZLRedColor;
        _pageControlPoint.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControlPoint;
}

- (NSInteger)totalItemCount {
    return _swipeView.numberOfItems;
}

- (NSInteger)currentIndex {
    return _swipeView.currentItemIndex;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _swipeView.currentItemIndex = currentIndex;
}


- (BOOL)wrapEnabled {
    return _swipeView.wrapEnabled;
}

- (void)setWrapEnabled:(BOOL)wrapEnabled {
    _swipeView.wrapEnabled = wrapEnabled;
}


#pragma mark - setter
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    if (currentPageColor) {
        _pageControlPoint.currentPageIndicatorTintColor = currentPageColor;
    }
}


#pragma mark - animation
- (void)stopAnimation {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startAnimation {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:SliderBannerChangeInterval
                                         target:[MWeakProxy proxyWithTarget:self]
                                       selector:@selector(startScroll)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)startScroll {
    if (!_swipeView.isScrolling) {
        [_swipeView scrollToItemAtIndex:_swipeView.currentItemIndex + 1 duration:SliderAutoScrollDuration];
    }
}


#pragma mark SliderView DataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInSliderView:)]) {
        return [self.dataSource numberOfItemsInSliderView:self];
    }
    return 0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if ([self.dataSource respondsToSelector:@selector(sliderView:viewForItemAtIndex:reusingView:)]) {
        return [self.dataSource sliderView:self viewForItemAtIndex:index reusingView:view];
    }
    return nil;
}

- (void)reloadData {
    _swipeView.height = self.height;
    [_swipeView reloadData];
    [self reloadPageControl];
}

- (void)reloadPageControl {
    if (_pageControlPoint){
        _pageControlPoint.numberOfPages = _swipeView.numberOfPages;
        _pageControlPoint.currentPage = 0;
        if (_swipeView.numberOfPages <= 1 && self.disableScrollOnlyOneImage) {
            _swipeView.scrollEnabled = NO;
        }
    }
    
    if (_pageControlNum) {
        _pageControlNum.numberOfPages = _swipeView.numberOfPages;
        _pageControlNum.currentPage = 0;
        if (_swipeView.numberOfPages <= 1&& self.disableScrollOnlyOneImage) {
            _swipeView.scrollEnabled = NO;
        }
    }
}


#pragma mark SwipeView Delegate
- (void)scrollToItemAtIndex:(NSInteger)index {
    [_swipeView scrollToItemAtIndex:index duration:SliderAutoScrollDuration];
}

- (void)jumpToItemAtIndex:(NSInteger)index {
    [_swipeView scrollToItemAtIndex:index duration:0];
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    _pageControlPoint.currentPage = swipeView.currentItemIndex;
    _pageControlNum.currentPage = swipeView.currentItemIndex;
    if ([self.delegate respondsToSelector:@selector(sliderView:didSliderToIndex:)]) {
        [self.delegate sliderView:self didSliderToIndex:swipeView.currentItemIndex];
    }
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(sliderView:didSelectViewAtIndex:)]) {
        [self.delegate sliderView:self didSelectViewAtIndex:index];
    }
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView {
    if ([self.delegate respondsToSelector:@selector(sliderViewDidScroll:)]) {
        [self.delegate sliderViewDidScroll:self];
    }
}

- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView {
    if (self.autoScroll) {
        [self stopAnimation];
    }
    
    if ([self.delegate respondsToSelector:@selector(sliderViewWillBeginDragging:)]) {
        [self.delegate sliderViewWillBeginDragging:self];
    }
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self startAnimation];
    }
    if ([self.delegate respondsToSelector:@selector(sliderViewDidEndDragging:willDecelerate:)]) {
        [self.delegate sliderViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)swipeViewWillBeginDecelerating:(SwipeView *)swipeView {
    if ([self.delegate respondsToSelector:@selector(sliderViewWillBeginDecelerating:)]) {
        [self.delegate sliderViewWillBeginDecelerating:self];
    }
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    if ([self.delegate respondsToSelector:@selector(sliderViewDidEndDecelerating:)]) {
        [self.delegate sliderViewDidEndDecelerating:self];
    }
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView {
    if ([self.delegate respondsToSelector:@selector(sliderViewDidEndScrollingAnimation:)]) {
        [self.delegate sliderViewDidEndScrollingAnimation:self];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [_swipeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    if (_pageControlNum) {
        CGSize size = [_pageControlNum sizeForNumberOfPages:_swipeView.numberOfPages];
        [_pageControlNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
            make.bottom.equalTo(self.mas_bottom).offset(-3);
            if (self.alignment == SliderViewPageControlAlignmentLeft) {
                make.left.equalTo(self.mas_left).offset(10);
            } else if (self.alignment == SliderViewPageControlAlignmentRight) {
                make.right.equalTo(self.mas_right).offset(-10);
            } else {
                make.centerX.equalTo(self.mas_centerX);
            }
        }];
    }
    
    if (_pageControlPoint) {
        CGSize size = [_pageControlPoint sizeForNumberOfPages:_swipeView.numberOfPages];
        [_pageControlPoint mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
            make.bottom.equalTo(self.mas_bottom).offset(-3);
            if (self.alignment == SliderViewPageControlAlignmentLeft) {
                make.left.equalTo(self.mas_left).offset(20);
            } else if (self.alignment == SliderViewPageControlAlignmentRight) {
                make.right.equalTo(self.mas_right).offset(-20);
            } else {
                make.centerX.equalTo(self.mas_centerX);
            }
        }];
    }
}

- (void)dealloc {
    [self stopAnimation];
}

#pragma constraints
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
