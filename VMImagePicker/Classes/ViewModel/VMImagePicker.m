//
//  VMImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"
#import "VMImagePickerConfig.h"
#import "PHImageManager+ImagePicker.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMImagePicker ()
@property (strong, nonatomic) PHAsset *asset;
@property (assign, nonatomic) VMImagePickerConfig *config;
@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation VMImagePicker

- (instancetype)initWithAsset:(PHAsset *)asset config:(VMImagePickerConfig *)config {
    if (self = [super init]) {
        _asset = asset;
        _config = config;
        _requestId = PHInvalidImageRequestID;
    }
    return self;
}

- (void)getAssetCallback:(void (^ _Nonnull)(PHAsset *asset, VMImagePickerConfig *config, NSData *data))callback {
    @weakify(self);
    if (self.config.original) {
        PHImageRequestOptions *option = PHImageRequestOptions.new;
        option.networkAccessAllowed = YES;
        self.requestId = [PHImageManager.defaultManager requestImageDataAndOrientationForAsset:self.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            @strongify(self);
            if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
                return;
            }
            self.requestId = PHInvalidImageRequestID;
            callback(self.asset, self.config, imageData);
        }];
    } else {
        PHImageRequestOptions *option = PHImageRequestOptions.new;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
        self.requestId = [PHImageManager.defaultManager requestImageForAsset:self.asset targetSize:self.config.preferredSize contentMode:(PHImageContentModeAspectFill) options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            @strongify(self);
            BOOL finished = ![info[PHImageCancelledKey] boolValue] && result;
            if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
                return;
            }
            self.requestId = PHInvalidImageRequestID;
            callback(self.asset, self.config, UIImageJPEGRepresentation(result, self.config.compressionQuality));
        }];
    }
}

@end
