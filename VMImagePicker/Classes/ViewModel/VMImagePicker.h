//
//  VMImagePicker.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class VMImagePickerConfig;

@interface VMImagePicker : NSObject

- (void)getAssetCallback:(void (^ _Nonnull)(PHAsset *asset, VMImagePickerConfig *config, NSData *data))callback;

@end

NS_ASSUME_NONNULL_END
