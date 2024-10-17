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
@class VMImagePicker;

typedef NS_ENUM(NSInteger, VMImagePickerType) {
    VMImagePickerTypeNone,
    VMImagePickerTypeData,  // NSData
    VMImagePickerTypePath,  // NSString
};

typedef void (^VMImagePickerGetAssetBlock)(PHAsset * _Nonnull asset, VMImagePickerConfig * _Nonnull config, VMImagePicker * _Nonnull imagePicker);

@interface VMImagePicker : NSObject

@property (assign, nonatomic, readonly) VMImagePickerType type;
@property (strong, nonatomic, readonly) id object;              // Depend on property type.
@property (strong, nonatomic, readonly) NSError *error;

- (void)getAssetCallback:(VMImagePickerGetAssetBlock)callback;

@end

NS_ASSUME_NONNULL_END
