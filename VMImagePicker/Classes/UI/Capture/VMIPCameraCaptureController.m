//
//  VMIPCameraCaptureController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController.h"
#import "VMIPCameraCaptureController+Image.h"
#import "VMIPCameraCaptureController+Video.h"
#import "VMIPCameraCaptureController+Actions.h"
#import "VMIPCameraCaptureControl.h"

#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCapturePhotoOutput.h>

#import <Masonry/Masonry.h>

@interface VMIPCameraCaptureController () <VMIPCameraCaptureControlDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) VMIPCameraCaptureControl *captureControl;
@property (weak, nonatomic) AVCaptureDevice *cameraDevice;

#pragma mark - Actions
@property (weak, nonatomic) UIView *actionView;
@property (weak, nonatomic) UIView *focusView;
@property (assign, nonatomic) NSTimeInterval focusToken;

@end

@implementation VMIPCameraCaptureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    _session = AVCaptureSession.new;
    [self configForImage];
    self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self addCaptureActions];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
        AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:(AVCaptureDevicePositionBack)];
        AVCaptureDevice *cameraDevice = discoverySession.devices.firstObject;
        NSError *error;
        AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&error];
        self.cameraDevice = cameraDevice;
        [self.session beginConfiguration];
        if ([self.session canAddInput:cameraInput]) {
            [self.session addInput:cameraInput];
        }
        [self.session commitConfiguration];
        [self.session startRunning];
    });
    self.captureControl.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.videoPreviewLayer.frame = self.view.bounds;
}

#pragma mark - VMIPCameraCaptureControlDelegate

- (void)imageTakenCaptureControl:(VMIPCameraCaptureControl *)captureControl {
    
}

- (void)videoStartedCaptureControl:(VMIPCameraCaptureControl *)captureControl {
    
}

- (void)videoStopedCaptureControl:(VMIPCameraCaptureControl *)captureControl {
    
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

- (VMIPCameraCaptureControl *)captureControl {
    if (_captureControl) {
        return _captureControl;
    }
    VMIPCameraCaptureControl *captureControl = VMIPCameraCaptureControl.new;
    _captureControl = captureControl;
    [self.view addSubview:_captureControl];
    [_captureControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0f, 60.0f));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    return captureControl;
}

@end
