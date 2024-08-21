//
//  PHPhotoLibrary+ImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/16.
//

#import "PHPhotoLibrary+ImagePicker.h"

@implementation PHPhotoLibrary (ImagePicker)

+ (PHAuthorizationStatus)albumAuthorizationStatus {
    if (@available(iOS 14.0, *)) {
        return [self authorizationStatusForAccessLevel:(PHAccessLevelReadWrite)];
    }
    return [self authorizationStatus];
}

+ (void)requestAlbumAuthorization:(void (^)(PHAuthorizationStatus status))handler {
    if (@available(iOS 14.0, *)) {
        return [self requestAuthorizationForAccessLevel:(PHAccessLevelReadWrite) handler:handler];
    }
    return [self requestAuthorization:handler];
}

@end
