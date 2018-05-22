//
//  ZLNavigationBar.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/8.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ZLNavigationBar.h"

@interface ZLNavigationBar()

@property(nonatomic, strong) UIView *bottomBorder;

@end

@implementation ZLNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame needBlurEffect:YES];
}

- (id)initWithFrame:(CGRect)frame needBlurEffect:(BOOL)needBlurEffect {
    if (self = [super initWithFrame:frame]) {
        
        if (needBlurEffect) {
            [self addSubview:self.effectView];
            [self.effectView.contentView addSubview:self.containerView];
            
        } else {
            self.backgroundColor = ZLWhiteColor;
            [self addSubview:self.containerView];
        }
        
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.bottomBorder];
    }
    return self;
}

#pragma mark - property
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.tintColor = ZLWhiteColor;
    }
    return _effectView;
}

- (UIView *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [[UIView alloc] init];
        _bottomBorder.backgroundColor = ZLClearColor;
    }
    return _bottomBorder;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = ZLClearColor;
        _titleLabel.textColor = ZLThemeCtrInstance.titleColor;
        _titleLabel.font = ZLNormalFont(20 * SCALE);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 14 / 18.f;
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _containerView.frame = CGRectMake(0, STATUSBARHEIGHT, SCREENWIDTH, NAVBARCONTAINERHEIGHT);
    _effectView.frame = CGRectMake(0, 0, SCREENWIDTH, NAVBARHEIGHT);
    _bottomBorder.frame = CGRectMake(0, NAVBARCONTAINERHEIGHT - LINEWIDTH, SCREENWIDTH, LINEWIDTH);
    _titleLabel.frame = CGRectMake(0, 0, SCREENWIDTH, NAVBARCONTAINERHEIGHT);
    
    _rightButton.center = CGPointMake(_containerView.width - _rightButton.width/2 - 8, _containerView.height/2);
    _rightDesButton.right = _rightButton.left;
    _rightDesButton.centerY = _rightButton.centerY;
    _leftButton.center = CGPointMake(_leftButton.width/2 + 8, _containerView.height/2);
    
    _middleView.centerY = _containerView.height / 2;
    CGFloat _middleLeft = 0;
    CGFloat _middleRight = 0;
    if (_leftButton) {
        _middleView.left = _leftButton.right + 8;
        _middleLeft = _leftButton.right + 8;;
    } else {
        _middleView.left = 20;
        _middleLeft = 20;
    }
    
    if (_rightDesButton) {
        _middleRight = _rightDesButton.left - 8;
    } else if(_rightButton) {
        _middleRight = _rightButton.left - 8;
    } else {
        _middleRight = _containerView.width - 20;
    }
    _middleView.width = _middleRight - _middleLeft;
}

#pragma mark - public method
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor*)color {
    _titleLabel.textColor = color;
}

- (void)setLeftButton:(UIView *)leftButton {
    if (leftButton == _leftButton) {
        return;
    }
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    _leftButton = leftButton;
    if ([leftButton isKindOfClass:[UIButton class]]) {
        [((UIButton *)leftButton) setTitleColor:ZLThemeCtrInstance.navigationButtonColor
                                    forState:UIControlStateNormal];
        [((UIButton *)leftButton) setTintColor:ZLThemeCtrInstance.navigationButtonColor];
    }
    [self.containerView addSubview:leftButton];
}

- (void)setRightButton:(UIView *)rightButton {
    if (rightButton == _rightButton) {
        return;
    }
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    _rightButton = rightButton;
    if ([rightButton isKindOfClass:[UIButton class]]) {
        [((UIButton *)rightButton) setTitleColor:ZLThemeCtrInstance.navigationButtonColor
                                       forState:UIControlStateNormal];
        [((UIButton *)rightButton) setTintColor:ZLThemeCtrInstance.navigationButtonColor];
    }
    
    [self.containerView addSubview:rightButton];
    [self setNeedsLayout];
}

- (void)setRightDesButton:(UIView *)rightDesButton {
    if (rightDesButton == _rightDesButton) {
        return;
    }
    if (_rightDesButton) {
        [_rightDesButton removeFromSuperview];
    }
    _rightDesButton = rightDesButton;
    if ([rightDesButton isKindOfClass:[UIButton class]]) {
        [((UIButton *)rightDesButton) setTitleColor:ZLThemeCtrInstance.navigationButtonColor
                                        forState:UIControlStateNormal];
        [((UIButton *)rightDesButton) setTintColor:ZLThemeCtrInstance.navigationButtonColor];
    }
    
    [self.containerView addSubview:rightDesButton];
    [self setNeedsLayout];
}

- (void)setMiddleView:(UIView *)middleView {
    if (middleView == _middleView) {
        return;
    }
    if (_middleView) {
        [_middleView removeFromSuperview];
    }
    _middleView = middleView;
    [self.containerView addSubview:middleView];
    [self setNeedsLayout];
}

- (void)setBottomBorderColor:(UIColor *)color {
    self.bottomBorder.backgroundColor = color;
}

@end
