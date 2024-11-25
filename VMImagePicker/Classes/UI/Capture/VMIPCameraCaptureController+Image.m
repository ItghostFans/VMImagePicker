//
//  VMIPCameraCaptureController+Image.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController+Image.h"
#import "VMIPCameraCaptureController+Private.h"

#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCapturePhotoOutput.h>
#import <CoreVideo/CVPixelBuffer.h>

@interface VMIPCameraCaptureController () <AVCapturePhotoCaptureDelegate>
@end

@implementation VMIPCameraCaptureController (Image)

- (void)configForImage {
    [_session beginConfiguration];
    if ([_session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    [_session commitConfiguration];
}

- (void)takeImage {
    AVCapturePhotoSettings *photoSetting = AVCapturePhotoSettings.new;
    OSType pixelFormatType = photoSetting.availablePreviewPhotoPixelFormatTypes.firstObject;
    NSMutableDictionary *setting = NSMutableDictionary.new;
    setting[(__bridge id)kCVPixelBufferPixelFormatTypeKey] = @(pixelFormatType);
    photoSetting.previewPhotoFormat = setting;
    AVCapturePhotoOutput *output = AVCapturePhotoOutput.new;
    [_session beginConfiguration];
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    [_session commitConfiguration];
    [output capturePhotoWithSettings:photoSetting delegate:self];
    [_session beginConfiguration];
    [_session removeOutput:output];
    [_session commitConfiguration];
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    photo.fileDataRepresentation;
}

@end
