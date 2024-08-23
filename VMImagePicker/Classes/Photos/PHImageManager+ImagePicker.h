//
//  PHImageManager+ImagePicker.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/7/10.
//

#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHImageManager (ImagePicker)

- (PHImageRequestID)requestImageOfAsset:(PHAsset *)asset
                                   size:(CGSize)size
                            contentMode:(PHImageContentMode)contentMode
                             completion:(void (^)(BOOL finished, BOOL inCloud, UIImage *_Nullable result, NSDictionary *_Nullable info))completion;

@end

NS_ASSUME_NONNULL_END
