//
//  VMIPCameraCaptureController+Actions.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/21.
//

#import "VMIPCameraCaptureController+Actions.h"
#import "VMIPCameraCaptureController+Private.h"

#import <Masonry/Masonry.h>

@implementation VMIPCameraCaptureController (Actions)

- (void)addCaptureActions {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.actionView addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
        [self.actionView addGestureRecognizer:pinch];
}

#pragma mark - Actions

// 聚焦
- (void)onTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    
    NSError *error;
    if ([_cameraDevice lockForConfiguration:&error]) {
        if ([_cameraDevice.activeFormat isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematic]) {
            [_videoPreviewLayer.connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeCinematic];
        } else if ([_cameraDevice.activeFormat isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeStandard]) {
            [_videoPreviewLayer.connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeStandard];
        }
        if ([_cameraDevice isFocusPointOfInterestSupported] && [_cameraDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [_cameraDevice setFocusPointOfInterest:[_videoPreviewLayer captureDevicePointOfInterestForPoint:point]];
            [_cameraDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [_cameraDevice unlockForConfiguration];
    }
    
    [CATransaction begin];
    [self.focusView.layer removeAllAnimations];
    [CATransaction commit];
    self.focusView.center = point;
    self.focusView.alpha = 1.0f;
    self.focusView.transform = CGAffineTransformIdentity;
    
    NSTimeInterval focusToken = [NSDate.new timeIntervalSince1970];
    _focusToken = focusToken;
    [UIView animateWithDuration:0.3f animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    } completion:^(BOOL finished) {
        if (self.focusToken != focusToken) {
            return;
        }
        [UIView animateWithDuration:0.2f animations:^{
            self.focusView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (self.focusToken != focusToken) {
                return;
            }
            self.focusView.transform = CGAffineTransformIdentity;
        }];
    }];
}

// 变焦
- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateChanged: {
            if (fabs(pinch.velocity) < 0.5f) {
                pinch.scale = 1.0;
                return;
            }
            NSError *error;
            if ([_cameraDevice lockForConfiguration:&error]) {
                CGFloat zoomFactor = 1.0f;
                if (pinch.scale < 1.0f) {
                    zoomFactor = _cameraDevice.videoZoomFactor / 1.05f;
                } else
                if (_cameraDevice.videoZoomFactor >= 1.0f) {
                    zoomFactor = 1.05f * _cameraDevice.videoZoomFactor;
                }
                zoomFactor = MAX(1.0f, MIN(zoomFactor, _cameraDevice.activeFormat.videoMaxZoomFactor));
                [_cameraDevice setVideoZoomFactor:zoomFactor];
                [_cameraDevice unlockForConfiguration];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            pinch.scale = 1.0;
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Getter

- (UIView *)actionView {
    if (_actionView) {
        return _actionView;
    }
    UIView *actionView = UIView.new;
    _actionView = actionView;
    [self.view addSubview:_actionView];
    [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return actionView;
}

- (UIView *)focusView {
    if (_focusView) {
        return _focusView;
    }
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    _focusView = focusView;
    _focusView.backgroundColor = UIColor.clearColor;
    _focusView.layer.borderColor = UIColor.yellowColor.CGColor;
    _focusView.layer.borderWidth = 1.0;
    [self.actionView addSubview:_focusView];
    return focusView;
}

@end
