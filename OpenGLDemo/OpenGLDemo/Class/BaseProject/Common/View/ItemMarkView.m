//
//  ItemMarkView.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/10/20.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ItemMarkView.h"

#define DefaultMarkWidth 15
#define DefaultLabelFont 12

@interface ItemMarkView()

@property (nonatomic, strong) NSMutableArray<UIButton* > *starViews;
@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation ItemMarkView

#pragma mark - public method
- (void)setMark:(CGFloat)mark {
    if (_mark != mark) {
        _mark = mark;
        for (int i = 0; i < 5; i++) {
            UIButton *button = self.starViews[i];
            if (i+1 <= mark) {
                [button setBackgroundImage:[UIImage imageNamed:@"star_all"] forState:UIControlStateNormal];
            }else{
                float distance = i+1 - mark;
                if (distance > 0.6) {
                    [button setBackgroundImage:[UIImage imageNamed:@"star_none"] forState:UIControlStateNormal];
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:@"star_half"] forState:UIControlStateNormal];
                }
            }
        }
        self.markLabel.text = [NSString stringWithFormat:@"%.1f",mark];
        [self setNeedsLayout];
    }
}

- (void)setMarkWidth:(CGFloat)markWidth {
    _markWidth = markWidth;
    [self setNeedsLayout];
}

- (void)setLabelFont:(CGFloat)labelFont {
    _labelFont = labelFont;
    self.markLabel.font = ZLNormalFont(labelFont);
    [self setNeedsLayout];
}

- (void)setShowMark:(BOOL)showMark {
    _showMark = showMark;
    self.markLabel.hidden = !showMark;
    [self setNeedsLayout];
}
#pragma mark - override
- (void)initComponent {
    _mark = 0.f;
    _showMark = YES;
    _markWidth = DefaultMarkWidth;
    _labelFont = DefaultLabelFont;
    
    for (UIButton *button in self.starViews) {
        [self addSubview:button];
    }
    [self addSubview:self.markLabel];
}

- (NSArray *)starViews {
    if (!_starViews) {
        NSMutableArray *stars = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundImage:[UIImage imageNamed:@"star_none"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(starButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [stars addObject:button];
        }
        _starViews = stars;
    }
    return _starViews;
}

- (UILabel*)markLabel {
    if (!_markLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = ZLRGB(254, 187, 20);
        label.text = @"0.0";
        _markLabel = label;
    }
    return _markLabel;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize viewSize = CGSizeZero;
    viewSize.height = 4 + self.markWidth;
    CGFloat markLabelWidth = self.showMark ? self.markLabel.width : 0;
    viewSize.width = (self.markWidth + 5) * 5 + markLabelWidth;
    NSLog(@"width %f, height %f", viewSize.width, viewSize.height);
    return viewSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < 5; i++) {
        UIView *view = _starViews[i];
        view.size = CGSizeMake(_markWidth, _markWidth);
        view.left = (_markWidth + 5) * i;
        view.centerY = self.height / 2;
    }
    
    [_markLabel sizeToFit];
    _markLabel.left = (_markWidth + 5) * 5;
    _markLabel.centerY = self.height / 2;
}

#pragma mark -
- (void)starButtonTapped:(id)sender {
    NSInteger index = [self.starViews indexOfObject:sender];
    self.mark = index + 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeMarkValue:)]) {
        [self.delegate changeMarkValue:self];
    }
}
@end
