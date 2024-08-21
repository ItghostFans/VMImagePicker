//
//  PHPhotoLibrary+ImagePicker.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/16.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPhotoLibrary (ImagePicker)

+ (PHAuthorizationStatus)albumAuthorizationStatus;
+ (void)requestAlbumAuthorization:(void (^)(PHAuthorizationStatus status))handler;

@end

NS_ASSUME_NONNULL_END
