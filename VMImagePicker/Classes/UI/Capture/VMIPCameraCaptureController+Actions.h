//
//  VMIPCameraCaptureController+Actions.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/21.
//

#import "VMIPCameraCaptureController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VMIPCameraFocusState) {
    VMIPCameraFocusStateNone,
    VMIPCameraFocusStateAppearing,
    VMIPCameraFocusStateDisappearing,
};

@interface VMIPCameraCaptureController (Actions)

- (void)addCaptureActions;

@end

NS_ASSUME_NONNULL_END
