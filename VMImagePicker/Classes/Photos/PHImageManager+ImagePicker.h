//
//  PHImageManager+ImagePicker.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/7/10.
//

#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHImageManager (ImagePicker)

- (PHImageRequestID)requestImageOfAsset:(PHAsset * _Nonnull)asset
                                   size:(CGSize)size
                            contentMode:(PHImageContentMode)contentMode
                             completion:(void (^ _Nonnull)(BOOL finished, BOOL inCloud, BOOL degraded, UIImage *_Nullable result, NSDictionary *_Nullable info))completion;

- (PHImageRequestID)requestImageOfAsset:(PHAsset * _Nonnull)asset
                            progressing:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))progressing
                             completion:(void (^ _Nonnull)(BOOL finished, UIImage *_Nullable result, NSDictionary *_Nullable info))completion;

@end

NS_ASSUME_NONNULL_END
