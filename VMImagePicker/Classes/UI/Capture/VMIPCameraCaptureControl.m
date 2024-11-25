//
//  VMIPCameraCaptureControl.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/17.
//

#import "VMIPCameraCaptureControl.h"

@interface VMIPCameraCaptureControl ()
@property (weak, nonatomic) CALayer *tapLayer;
@end

@implementation VMIPCameraCaptureControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tapLayer.frame = self.bounds;
    self.tapLayer.cornerRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2;
}

#pragma mark - Actions

- (void)onTap:(UITapGestureRecognizer *)tap {
    [_delegate imageTakenCaptureControl:self];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [_delegate videoStartedCaptureControl:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            [_delegate videoStopedCaptureControl:self];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Getter

- (CALayer *)tapLayer {
    if (_tapLayer) {
        return _tapLayer;
    }
    CALayer *tapLayer = CALayer.new;
    _tapLayer = tapLayer;
    _tapLayer.backgroundColor = UIColor.whiteColor.CGColor;
    [self.layer addSublayer:_tapLayer];
    return tapLayer;
}

@end
