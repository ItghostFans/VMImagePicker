//
//  VMImagePickerController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VMImagePickerState) {
    VMImagePickerStateNone      = 0,
    VMImagePickerStateCancel    = 1,
    VMImagePickerStateDone      = 2,
};

@class VMImagePickerStyle;
@class VMImagePickerConfig;
@class VMImagePickerController;

UIKIT_EXTERN UIImagePickerControllerInfoKey const VMImagePickersKey;

@protocol VMImagePickerControllerDelegate<NSObject>
@optional
- (void)imagePickerController:(VMImagePickerController *)controller didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info;
- (void)imagePickerControllerDidCancel:(VMImagePickerController *)controller;

@end

@interface VMImagePickerController : UINavigationController

@property (strong, nonatomic, readonly, nonnull) VMImagePickerStyle *style;
@property (strong, nonatomic, readonly, nonnull) VMImagePickerConfig *config;

@property (weak, nonatomic, nullable) id<VMImagePickerControllerDelegate> imagePickerDelegate;

#pragma mark - UIImagePickerController
@property (assign, nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;

@end

NS_ASSUME_NONNULL_END
