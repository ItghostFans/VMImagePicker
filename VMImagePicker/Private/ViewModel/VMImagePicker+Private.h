//
//  VMImagePicker+Private.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerConfig;

@interface VMImagePicker ()
- (instancetype)initWithAsset:(PHAsset *)asset config:(VMImagePickerConfig *)config;
@end

NS_ASSUME_NONNULL_END
