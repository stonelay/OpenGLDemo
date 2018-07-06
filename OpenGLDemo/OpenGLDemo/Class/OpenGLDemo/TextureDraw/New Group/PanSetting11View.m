//
//  PanSetting11View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/6.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "PanSetting11View.h"
#import "GLRender11View.h"
#import "DrawModel.h"

@interface PanSetting11View()

//@property (nonatomic, assign) float pointSize;
//@property (nonatomic, assign) float r;
//@property (nonatomic, assign) float g;
//@property (nonatomic, assign) float b;

@property (nonatomic, strong) UISlider *rSlider;
@property (nonatomic, strong) UISlider *gSlider;
@property (nonatomic, strong) UISlider *bSlider;
@property (nonatomic, strong) UISlider *sSlider;

@property (nonatomic, strong) UIView *panView;

@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *replayButton;
@property (nonatomic, strong) UIButton *undoButton;

@end

@implementation PanSetting11View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.backgroundColor = ZLWhiteColor;
    [self addSubview:self.rSlider];
    [self addSubview:self.gSlider];
    [self addSubview:self.bSlider];
    [self addSubview:self.sSlider];
    [self addSubview:self.panView];
    
    [self addSubview:self.clearButton];
    [self addSubview:self.replayButton];
    [self addSubview:self.undoButton];
    
    [self sliderValueChanged:nil];
}

- (UISlider *)rSlider {
    if (!_rSlider) {
        _rSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 30, 10 * SCALE, SCREENWIDTH/2, 60 * SCALE)];
        _rSlider.minimumValue = 0;// 设置最小值
        _rSlider.maximumValue = 255;// 设置最大值
        _rSlider.value = 0;// 设置初始值
        _rSlider.continuous = YES;// 设置可连续变化
        [_rSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rSlider;
}

- (UISlider *)gSlider {
    if (!_gSlider) {
        _gSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 30, 10 * SCALE + self.rSlider.bottom, SCREENWIDTH/2, 60 * SCALE)];
        _gSlider.minimumValue = 0;// 设置最小值
        _gSlider.maximumValue = 255;// 设置最大值
        _gSlider.value = 255;// 设置初始值
        _gSlider.continuous = YES;// 设置可连续变化
        [_gSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _gSlider;
}

- (UISlider *)bSlider {
    if (!_bSlider) {
        _bSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 30, 10 * SCALE + self.gSlider.bottom, SCREENWIDTH/2, 60 * SCALE)];
        _bSlider.minimumValue = 0;// 设置最小值
        _bSlider.maximumValue = 255;// 设置最大值
        _bSlider.value = 0;// 设置初始值
        _bSlider.continuous = YES;// 设置可连续变化
        [_bSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _bSlider;
}

- (UISlider *)sSlider {
    if (!_sSlider) {
        _sSlider = [[UISlider alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 30, 10 * SCALE + self.bSlider.bottom, SCREENWIDTH/2, 60 * SCALE)];
        _sSlider.minimumValue = 0;// 设置最小值
        _sSlider.maximumValue = 100;// 设置最大值
        _sSlider.value = 30;// 设置初始值
        _sSlider.continuous = YES;// 设置可连续变化
        [_sSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _sSlider;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        _clearButton.size = CGSizeMake(SCREENWIDTH / 3, 40);
        _clearButton.bottom = self.height;
        _clearButton.left = 0;
        [_clearButton setTitle:@"全部清除" forState:UIControlStateNormal];
        [_clearButton setTitleColor:ZLBlackColor forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIButton *)replayButton {
    if (!_replayButton) {
        _replayButton = [[UIButton alloc] init];
        _replayButton.size = CGSizeMake(SCREENWIDTH / 3, 40);
        _replayButton.bottom = self.height;
        _replayButton.left = self.clearButton.right;;
        [_replayButton setTitle:@"重绘" forState:UIControlStateNormal];
        [_replayButton setTitleColor:ZLBlackColor forState:UIControlStateNormal];
        [_replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replayButton;
}

- (UIButton *)undoButton {
    if (!_undoButton) {
        _undoButton = [[UIButton alloc] init];
        _undoButton.size = CGSizeMake(SCREENWIDTH / 3, 40);
        _undoButton.bottom = self.height;
        _undoButton.left = self.replayButton.right;;
        [_undoButton setTitle:@"撤销" forState:UIControlStateNormal];
        [_undoButton setTitleColor:ZLBlackColor forState:UIControlStateNormal];
        [_undoButton addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoButton;
}

- (UIView *)panView {
    if (!_panView) {
        _panView = [[UIView alloc] init];
    }
    return _panView;
}

- (void)sliderValueChanged:(id)sender {
    self.panView.backgroundColor = [UIColor colorWithRed:self.rSlider.value / 255.0 green:self.gSlider.value / 255.0 blue:self.bSlider.value / 255.0 alpha:1.0];
    self.panView.size = CGSizeMake(self.sSlider.value, self.sSlider.value);
    self.panView.center = CGPointMake(80, self.height / 2);
    
    
    self.renderView.drawElement = self.drawElement;
}

- (DrawElement *)drawElement {
    DrawElement *drawElement = [[DrawElement alloc] init];
    drawElement.r = self.rSlider.value / 255.0;
    drawElement.g = self.gSlider.value / 255.0;
    drawElement.b = self.bSlider.value / 255.0;
    drawElement.pointSize = self.sSlider.value;
    return drawElement;
}
#pragma mark - handle

- (void)clear:(UIButton *)sender {
    [self.renderView clear];
}
- (void)replay:(UIButton *)sender {
    [self.renderView replay];
}
- (void)undo:(UIButton *)sender {
    [self.renderView undo];
}

@end
