//
//  PHImageManager+ImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/7/10.
//

#import "PHImageManager+ImagePicker.h"

@implementation PHImageManager (ImagePicker)

- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    PHImageRequestOptions *option = PHImageRequestOptions.new;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [PHImageManager.defaultManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (![info[PHImageCancelledKey] boolValue] && result) {
            // 返回本地相册图片。
            return;
        }
        if ([info[PHImageResultIsInCloudKey] boolValue] && !result) {   // 图片在iClound上。
            PHImageRequestOptions *options = PHImageRequestOptions.new;
            options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 处理下载进度。
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//                UIImage *resultImage = [UIImage imageWithData:imageData];
            }];
            
        }
    }];
}

- (PHImageRequestID)requestImageOfAsset:(PHAsset *)asset
                                   size:(CGSize)size
                            contentMode:(PHImageContentMode)contentMode
                             completion:(void (^)(BOOL finished, BOOL inCloud, UIImage *_Nullable result, NSDictionary *_Nullable info))completion {
    PHImageRequestOptions *option = PHImageRequestOptions.new;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [self requestImageForAsset:asset targetSize:size contentMode:contentMode options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            BOOL finished = ![info[PHImageCancelledKey] boolValue] && result;
            BOOL inCloud = [info[PHImageResultIsInCloudKey] boolValue] && !result;
            completion(finished, inCloud, result, info);
        }
    }];
}

- (PHImageRequestID)requestImageOfAsset:(PHAsset *)asset
                            progressing:(void (^)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))progressing
                             completion:(void (^)(BOOL finished, UIImage *_Nullable result, NSDictionary *_Nullable info))completion {
    PHImageRequestOptions *option = PHImageRequestOptions.new;
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        if (!progressing) {
            return;
        }
        progressing(progress, error, stop, info);
    };
    return [self requestImageDataAndOrientationForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        if (!completion) {
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(imageData.length, image, info);
            });
        });
    }];
}

@end
