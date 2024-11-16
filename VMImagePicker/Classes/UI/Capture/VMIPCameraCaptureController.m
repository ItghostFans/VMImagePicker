//
//  VMIPCameraCaptureController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController.h"
#import "VMIPCameraCaptureController+Image.h"
#import "VMIPCameraCaptureController+Video.h"

#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureInput.h>

@interface VMIPCameraCaptureController ()
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation VMIPCameraCaptureController

- (void)viewDidLoad {
    [super viewDidLoad];
    _session = AVCaptureSession.new;
    [self configForImage];
    self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:(AVCaptureDevicePositionBack)];
    AVCaptureDevice *cameraDevice = discoverySession.devices.firstObject;
    NSError *error;
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&error];
    [_session beginConfiguration];
    if ([_session canAddInput:cameraInput]) {
        [_session addInput:cameraInput];
    }
    [_session commitConfiguration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
        [self.session startRunning];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.videoPreviewLayer.frame = self.view.bounds;
}

#pragma mark - Getter

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (_videoPreviewLayer) {
        return _videoPreviewLayer;
    }
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _videoPreviewLayer = videoPreviewLayer;
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewLayer = videoPreviewLayer;
    [self.view.layer addSublayer:_videoPreviewLayer];
    return videoPreviewLayer;
}

@end
