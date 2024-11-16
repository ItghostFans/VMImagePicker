//
//  VMIPCameraCaptureController+Image.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController+Image.h"
#import "VMIPCameraCaptureController+Private.h"

#import <AVFoundation/AVCaptureSession.h>

@interface VMIPCameraCaptureController ()
{
    __strong AVCaptureSession *_session;
}
@end

@implementation VMIPCameraCaptureController (Image)

- (void)configForImage {
    [_session beginConfiguration];
    if ([_session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    [_session commitConfiguration];
}

@end
