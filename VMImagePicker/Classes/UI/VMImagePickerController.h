//
//  VMImagePickerController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;
@class VMImagePickerController;

UIKIT_EXTERN UIImagePickerControllerInfoKey const VMImagePickerControllerImages;

@protocol VMImagePickerControllerDelegate<NSObject>
@optional
- (void)imagePickerController:(VMImagePickerController *)controller didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info;
- (void)imagePickerControllerDidCancel:(VMImagePickerController *)picker;

@end

@interface VMImagePickerController : UINavigationController

@property (strong, nonatomic, readonly, nonnull) VMImagePickerStyle *style;

@property (weak, nonatomic, nullable) id<VMImagePickerControllerDelegate> imagePickerDelegate;

@end

NS_ASSUME_NONNULL_END
