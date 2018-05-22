//
//  ZLYESNOView.m
//  Caifuguanjia
//
//  Created by LayZhang on 2018/1/16.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLYESNOView.h"

@interface ZLYESNOView()

@property (nonatomic, strong) NSString *leftTitle;
@property (nonatomic, strong) NSString *rightTitle;

@end

@implementation ZLYESNOView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.leftTitle = leftTitle;
        self.rightTitle = rightTitle;
        [self initComponent];
        self.titleLabel.text = title;
        self.titleLabel.size = [title sizeWithUIFont:ZLNormalFont(16 * SCALE) forWidth:self.backView.width];
        if (![title isNotEmptyString]) {
            self.titleLabel.height = 0;
        }
        self.titleLabel.centerX = self.backView.width / 2;
        self.titleLabel.top = 10 * SCALE;
        
        self.messageLabel.text = message;
        self.messageLabel.size = [message sizeWithUIFont:ZLNormalFont(18 * SCALE) forWidth:self.backView.width];
        self.messageLabel.centerX = self.backView.width / 2;
        self.messageLabel.top = self.titleLabel.bottom + 10 * SCALE;
        
        self.backView.height = self.messageLabel.bottom + 60 * SCALE;
        self.backView.centerY = SCREENHEIGHT / 2;
        
        self.leftButton.bottom = self.backView.height;
        self.rightButton.bottom = self.backView.height;
        
    }
    return self;
}

- (void)initComponent {
    self.userInteractionEnabled = YES;
    [self addSubview:self.maskView];
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.messageLabel];
    [self.backView addSubview:self.leftButton];
    [self.backView addSubview:self.rightButton];
}

#pragma mark - subviews
- (UIButton *)maskView {
    if (!_maskView) {
        _maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _maskView.backgroundColor = ZLHEXCOLOR_a(0x000000, 0.5);
        self.maskView.alpha = 0;
        [_maskView addTarget:self action:@selector(maskAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

- (UIView *)backView {
    if (!_backView) {
        CGFloat height = self.messageLabel.text ? 130 * SCALE : 100 * SCALE;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225 * SCALE, height)];
        _backView.centerX = SCREENWIDTH / 2;
        _backView.centerY = SCREENHEIGHT / 2;
        _backView.backgroundColor = ZLWhiteColor;
        _backView.layer.cornerRadius = 14 * SCALE;
        _backView.userInteractionEnabled = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ZLNormalFont(14 * SCALE);
        _titleLabel.textColor = ZLHEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = ZLNormalFont(15 * SCALE);
        _messageLabel.textColor = ZLHEXCOLOR(0x333333);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        CGFloat width = 0;
        if ([self.leftTitle isNotEmptyString]) {
            width = self.backView.width;
            if ([self.rightTitle isNotEmptyString]) {
                width = self.backView.width / 2;
            }
        }
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40 * SCALE)];
        _leftButton.titleLabel.font = ZLNormalFont(15 * SCALE);
        _leftButton.layer.borderWidth = LINEWIDTH;
        _leftButton.layer.borderColor = ZLHEXCOLOR(0xeeeeee).CGColor;
        [_leftButton setTitleColor:ZLGray(51) forState:UIControlStateNormal];
        [_leftButton setTitle:self.leftTitle forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(buttonDidtouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        CGFloat width = 0;
        CGFloat left = 0;
        if ([self.rightTitle isNotEmptyString]) {
            width = self.backView.width;
            if ([self.leftTitle isNotEmptyString]) {
                width = self.backView.width / 2;
                left = self.backView.width / 2;
            }
        }
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(left, 0, width, 40 * SCALE)];
        _rightButton.titleLabel.font = ZLNormalFont(15 * SCALE);
        _rightButton.layer.borderWidth = LINEWIDTH;
        _rightButton.layer.borderColor = ZLHEXCOLOR(0xeeeeee).CGColor;
        [_rightButton setTitleColor:ZLThemeCtrInstance.backgroundColor forState:UIControlStateNormal];
        [_rightButton setTitle:self.rightTitle forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(buttonDidtouched:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightButton;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
    }];
    
    [UIView animateWithDuration:0.17 animations:^{
        self.backView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            self.backView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.backView.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {}];
        }];
    }];
}


#pragma mark - action method
- (void)buttonDidtouched:(UIButton *)button {
    
    if (button == self.leftButton) {
        self.leftAction(self);
    }
    
    if (button == self.rightButton) {
        self.rightAction(self);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0.0f;
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.backView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }];
}

- (void)maskAction {
    NSLog(@"....");
}

- (void)dealloc {
    NSLog(@"dealloc ..");
}

@end
