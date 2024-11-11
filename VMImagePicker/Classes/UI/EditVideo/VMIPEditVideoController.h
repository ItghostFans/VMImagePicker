//
//  VMIPEditVideoController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;
@class VMImagePickerConfig;
@class VMIPVideoEditViewModel;

@interface VMIPEditVideoController : UIViewController

@property (strong, nonatomic) VMIPVideoEditViewModel *viewModel;

@property (strong, nonatomic, readonly, nonnull) VMImagePickerStyle *style;
@property (strong, nonatomic, readonly, nonnull) VMImagePickerConfig *config;

@end

NS_ASSUME_NONNULL_END
