//
//  VMIPCameraCaptureController+Video.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController+Video.h"
#import "VMIPCameraCaptureController+Private.h"

#import <AVFoundation/AVCaptureSession.h>

@interface VMIPCameraCaptureController ()
@end

@implementation VMIPCameraCaptureController (Video)

- (void)configForVideo {
    [_session beginConfiguration];
    if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        _session.sessionPreset = AVCaptureSessionPresetHigh;
    } else
    if ([_session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        _session.sessionPreset = AVCaptureSessionPresetMedium;
    } else
    if ([_session canSetSessionPreset:AVCaptureSessionPresetLow]) {
        _session.sessionPreset = AVCaptureSessionPresetMedium;
    }
    [_session commitConfiguration];
}

@end
