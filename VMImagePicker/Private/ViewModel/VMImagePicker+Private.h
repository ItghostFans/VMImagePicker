//
//  VMImagePicker+Private.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"
#import "VMImagePickerConfig.h"
#import "PHImageManager+ImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerConfig;

@interface VMImagePicker ()

@property (assign, nonatomic) VMImagePickerType type;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) PHAsset *asset;
@property (assign, nonatomic) VMImagePickerConfig *config;
@property (assign, nonatomic) PHImageRequestID requestId;

- (instancetype)initWithAsset:(PHAsset *)asset config:(VMImagePickerConfig *)config;

- (NSString *)getDirectory:(NSString *)directory;

@end

NS_ASSUME_NONNULL_END
