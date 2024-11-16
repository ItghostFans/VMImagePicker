//
//  VMIPCameraCaptureController+Private.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/16.
//

#import "VMIPCameraCaptureController.h"

#import <AVFoundation/AVCaptureSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface VMIPCameraCaptureController ()
@property (strong, nonatomic) AVCaptureSession *session;
@end

NS_ASSUME_NONNULL_END
