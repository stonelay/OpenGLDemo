//
//  UIButton+ZLEX.m
//  LayZhangDemo
//
//  Created by LayZhang on 2017/5/10.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "UIButton+ZLEX.h"


static char topNameKey;
static char leftNameKey;
static char bottomNameKey;
static char rightNameKey;

@implementation UIButton (ZLEX)

#pragma mark - 快速创建button的方法
+ (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action tag:(NSInteger)tag buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight color:(NSInteger)color font:(NSInteger)font{
    
    UIButton *button = [[UIButton alloc] init];
    
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ZLRGB(color, color, color) forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(tag * buttonWidth, 0, buttonWidth, buttonHeight);
    
    return button;
}

//快速创建一个按钮
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(NSInteger)font{
    
    UIButton *button = [[UIButton alloc] init];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    //    button.backgroundColor = titleColor;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
    
}

//快速创建一个按钮 带图片
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(NSInteger)font imageNamed:(NSString *)imageNamed{
    
    UIButton *button = [[UIButton alloc] init];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    //    button.backgroundColor = [UIColor whiteColor];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (imageNamed) {
        
        [button setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    }
    
    [button sizeToFit];
    
    return button;
    
}

//快速创建一个按钮带背景图
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(NSInteger)font backImageNamed:(NSString *)name{
    
    UIButton *button = [[UIButton alloc] init];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    
    if (name) {
        
        [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    }
    
    button.backgroundColor = [UIColor whiteColor];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
    
}

//快速创建一个按钮带背景图
+ (UIButton *)buttonWithImage:(NSString *)imageName backImageNamed:(NSString *)backName{
    
    UIButton *button = [[UIButton alloc] init];
    
    if (imageName) {
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (backName) {
        
        [button setBackgroundImage:[UIImage imageNamed:backName] forState:UIControlStateNormal];
    }
    
    //    button.backgroundColor = [UIColor whiteColor];
    
    [button sizeToFit];
    
    return button;
    
}

+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage titleColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16.0f];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont   *titleFont   = ZLNormalFont(15.f);
    button.frame  = frame;
    button.titleLabel.font = titleFont;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ZLRedColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}

+ (UIButton *)buttonWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}


- (void)setEnlargeEdge:(CGFloat) size {
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right {
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:top],   OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:left],  OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:bottom],OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber* topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x    - leftEdge.floatValue,
                          self.bounds.origin.y    - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        
    } else
    {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}


@end
