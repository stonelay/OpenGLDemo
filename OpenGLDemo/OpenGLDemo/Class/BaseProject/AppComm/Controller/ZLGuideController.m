//
//  ZLGuideController.m
//  Caifuguanjia
//
//  Created by LayZhang on 2018/3/6.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLGuideController.h"
#import "ZLSliderView.h"

@interface ZLGuideController ()<ZLSliderViewDataSource, ZLSliderViewDelegate>

@property (nonatomic, strong) ZLSliderView *sliderView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) NSArray *guideArray;

@end

@implementation ZLGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sliderView];
    [self initData];
}

#pragma mark - properties
- (ZLSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZLSliderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)
                                                    style:SliderViewPageControlStylePoint
                                                alignment:SliderViewPageControlAlignmentCenter];
        _sliderView.delegate = self;
        _sliderView.dataSource = self;
        _sliderView.autoScroll = NO;
        _sliderView.wrapEnabled = NO;
        _sliderView.currentPageColor = ZLGray(233);
    }
    return _sliderView;
}

#pragma mark - override
- (void)initData {
    self.guideArray = @[@"guide_1",@"guide_2",@"guide_3"];
}

#pragma mark - TTSliderViewDataSource
- (NSInteger)numberOfItemsInSliderView:(ZLSliderView *)sliderView {
    return self.guideArray.count;
}

- (UIView *)sliderView:(ZLSliderView *)sliderView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sliderView.width, sliderView.height)];
        view.userInteractionEnabled = YES;
    }
    
    UIImageView *coverImageView = (UIImageView *) view;
    coverImageView.image = [UIImage imageNamed:self.guideArray[index]];
    
    if (index == 2) {
        [view addSubview:self.enterButton];
    } else {
        [view removeAllSubviews];
    }
    return view;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200 * SCALE, 30 * SCALE)];
        [_enterButton setBackgroundImage:[UIImage imageNamed:@"guide_enter"] forState:UIControlStateNormal];
        [_enterButton sizeToFit];
        
        _enterButton.centerX = SCREENWIDTH / 2;
        _enterButton.bottom = SCREENHEIGHT - 50 * SCALE;
        
        [_enterButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

#pragma mark - TTSliderViewDelegate

- (void)sliderView:(ZLSliderView *)sliderView didSelectViewAtIndex:(NSInteger)index {
    
}

- (void)enterAction {
    [[ApplicationEntity shareInstance] hideGuide];
}

@end
