//
//  VMImagePickerController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMImagePickerController : UINavigationController

@property (strong, nonatomic, readonly, nonnull) VMImagePickerStyle *style;

@end

NS_ASSUME_NONNULL_END
