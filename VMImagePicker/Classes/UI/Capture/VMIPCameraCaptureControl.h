//
//  VMIPCameraCaptureControl.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPCameraCaptureControl;

@protocol VMIPCameraCaptureControlDelegate <NSObject>
- (void)imageTakenCaptureControl:(VMIPCameraCaptureControl *)captureControl;
- (void)videoStartedCaptureControl:(VMIPCameraCaptureControl *)captureControl;
- (void)videoStopedCaptureControl:(VMIPCameraCaptureControl *)captureControl;
@end

@interface VMIPCameraCaptureControl : UIView
@property (weak, nonatomic) id<VMIPCameraCaptureControlDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
