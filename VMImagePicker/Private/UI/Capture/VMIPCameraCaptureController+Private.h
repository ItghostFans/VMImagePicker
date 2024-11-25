//
//  VMIPCameraCaptureController+Private.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController.h"
#import "VMIPCameraCaptureController+Actions.h"

#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface VMIPCameraCaptureController () {
    __strong AVCaptureSession *_session;
    __weak AVCaptureDevice *_cameraDevice;
    __weak AVCaptureVideoPreviewLayer *_videoPreviewLayer;
#pragma mark - Actions
    __weak UIView *_actionView;
    __weak UIView *_focusView;
    VMIPCameraFocusState _focusState;
}
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) AVCaptureDevice *cameraDevice;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

#pragma mark - Actions
@property (weak, nonatomic) UIView *actionView;
@property (weak, nonatomic) UIView *focusView;
@property (assign, nonatomic) VMIPCameraFocusState focusState;
@end

NS_ASSUME_NONNULL_END
