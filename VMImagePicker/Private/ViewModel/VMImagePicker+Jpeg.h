//
//  VMImagePicker+Jpeg.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/14.
//

#import "VMImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class VMImagePickerConfig;

@interface VMImagePicker (Jpeg)
- (void)getJpegAssetCallback:(VMImagePickerGetAssetBlock)callback;
@end

NS_ASSUME_NONNULL_END
