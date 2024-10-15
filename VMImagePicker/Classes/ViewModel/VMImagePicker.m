//
//  VMImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"
#import "VMImagePicker+Jpeg.h"
#import "VMImagePickerConfig.h"
#import "PHImageManager+ImagePicker.h"

#import <Photos/PHAsset.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMImagePicker ()

@property (assign, nonatomic) VMImagePickerType type;
@property (strong, nonatomic) id object;

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

- (void)getAssetCallback:(VMImagePickerGetAssetBlock)callback {
    switch (_asset.mediaType) {
        case PHAssetMediaTypeImage: {
            [self getJpegAssetCallback:callback];
            break;
        }
//        case PHAssetMediaTypeVideo: {
//            break;
//        }
        default: {
            callback(self.asset, self.config, self);
            break;
        }
    }
}

@end
