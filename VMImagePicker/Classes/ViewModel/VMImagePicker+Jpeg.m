//
//  VMImagePicker+Jpeg.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/14.
//

#import "VMImagePicker+Jpeg.h"
#import "VMImagePicker+Private.h"

#import <ReactiveObjC/ReactiveObjC.h>

@implementation VMImagePicker (Jpeg)

- (void)getJpegAssetCallback:(VMImagePickerGetAssetBlock)callback {
    @weakify(self);
    if (self.config.original) {
        PHImageRequestOptions *option = PHImageRequestOptions.new;
        option.networkAccessAllowed = YES;
        self.requestId = [PHImageManager.defaultManager requestImageDataAndOrientationForAsset:self.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            @strongify(self);
            if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
                callback(self.asset, self.config, self);
                return;
            }
            self.requestId = PHInvalidImageRequestID;
            self.type = VMImagePickerTypeData;
            self.object = imageData;
            callback(self.asset, self.config, self);
        }];
    } else {
        PHImageRequestOptions *option = PHImageRequestOptions.new;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
        self.requestId = [PHImageManager.defaultManager requestImageForAsset:self.asset targetSize:self.config.preferredSize contentMode:(PHImageContentModeAspectFill) options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            @strongify(self);
            if ([info[PHImageResultIsDegradedKey] boolValue]) {
                return;
            }
            if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
                callback(self.asset, self.config, self);
                return;
            }
            self.requestId = PHInvalidImageRequestID;
            VMImagePickerConfig *config = self.config;
            PHAsset *asset = self.asset;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (uintptr_t)NULL), ^{
                @strongify(self);
                NSData *data = UIImageJPEGRepresentation(result, config.compressionQuality);
                self.type = VMImagePickerTypeData;
                self.object = data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    callback(asset, config, self);
                });
            });
        }];
    }
}

@end
