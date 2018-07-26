//
//  ZLPaintView.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/7/24.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "ZLPaintView.h"
#import "ZLGridePainter.h"
#import "ZLCandlePainter.h"

#import "KLineDataCenter.h"

@interface ZLPaintView()<KLineDataSource>

@property (nonatomic, strong) NSMutableArray *drawDataArray;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;       //
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;   //
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;//

@end

@implementation ZLPaintView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefault];
        [self loadData];
    }
    return self;
}

- (void)initDefault {
    self.backgroundColor = ZLGray(234);
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self addGestureRecognizer:self.pinchGesture];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self addGestureRecognizer:self.longPressGesture];
}

- (void)loadData {
    self.drawDataArray = [KLineDataCenter shareInstance].hisKLineDataArray;
}

- (NSArray *)painterArray {
    if (!_painterArray) {
        NSMutableArray *tempArray = [NSMutableArray new];
        if (self.linePainterOp & ZLKLinePainterOpGride) {
            ZLBasePainter *painter = [[ZLGridePainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            [tempArray addObject:painter];
        }
        
        if (self.linePainterOp & ZLKLinePainterOpCandle) {
            ZLBasePainter *painter = [[ZLCandlePainter alloc] initWithPaintView:self];
            painter.dataSource = self;
            [tempArray addObject:painter];
        }
        
        _painterArray = [tempArray copy];
    }
    return _painterArray;
}

- (void)draw {
    if (self.painterArray && self.painterArray.count != 0) {
        for (int i = 0; i < self.painterArray.count; i++) {
            [self.painterArray[i] draw];
        }
    }
}

#pragma mark - KLineDataSource
- (NSUInteger)maxNumberOfPainter:(ZLBasePainter *)painter {
    return self.drawDataArray.count;
}

- (NSArray *)paintArrayFrom:(NSUInteger)fIndex length:(NSUInteger)length painter:(ZLBasePainter *)painter {
    return [self.drawDataArray subarrayWithRange:NSMakeRange(fIndex, length)];
}

#pragma mark - gesture
- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] panChangedPoint:point];
                }
            }
        }
            break;
        case UIGestureRecognizerStateBegan: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] panBeganPoint:point];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] panEndedPoint:point];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] pinchChangedScale:gesture.scale];
                }
            }
        }
            break;
        case UIGestureRecognizerStateBegan: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] pinchBeganScale:gesture.scale];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] pinchEndedScale:gesture.scale];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] longPressChangedLocation:point];
                }
            }
        }
            break;
        case UIGestureRecognizerStateBegan: {
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] longPressBeganLocation:point];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (self.painterArray && self.painterArray.count != 0) {
                for (int i = 0; i < self.painterArray.count; i++) {
                    [self.painterArray[i] longPressEndedLocation:point];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - control
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

@end
