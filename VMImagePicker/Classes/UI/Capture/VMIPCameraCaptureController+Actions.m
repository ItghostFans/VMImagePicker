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
}

#pragma mark - Actions

- (void)onTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    
    NSError *error;
    if ([_cameraDevice lockForConfiguration:&error]) {
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
    
    [UIView animateWithDuration:0.3f animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.focusState = VMIPCameraFocusStateAppearing;
    } completion:^(BOOL finished) {
        if (self.focusState != VMIPCameraFocusStateAppearing) {
            return;
        }
        [UIView animateWithDuration:0.2f animations:^{
            self.focusView.alpha = 0.0f;
            self.focusState = VMIPCameraFocusStateDisappearing;
        } completion:^(BOOL finished) {
            if (self.focusState != VMIPCameraFocusStateDisappearing) {
                return;
            }
            self.focusView.transform = CGAffineTransformIdentity;
            self.focusState = VMIPCameraFocusStateNone;
        }];
    }];
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
