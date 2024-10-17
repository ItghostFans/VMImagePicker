//
//  VMImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"
#import "VMImagePicker+Jpeg.h"
#import "VMImagePicker+Mp4.h"
#import "VMImagePickerConfig.h"
#import "PHImageManager+ImagePicker.h"

#import <Photos/PHAsset.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMImagePicker ()

@property (assign, nonatomic) VMImagePickerType type;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) VMImagePickerConfig *config;
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

- (NSString *)getDirectory:(NSString *)directory {
    directory = [self.config.directory stringByAppendingPathComponent:directory];
    BOOL isDirectory = NO;
    NSError *error;
    if ([NSFileManager.defaultManager fileExistsAtPath:directory isDirectory:&isDirectory]) {
        if (!isDirectory) {
            [NSFileManager.defaultManager removeItemAtPath:directory error:&error];
            NSAssert(!error, @"Check %@", error);
            [NSFileManager.defaultManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"Check %@", error);
        }
    } else {
        [NSFileManager.defaultManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(!error, @"Check %@", error);
    }
    return directory;
}

- (void)getAssetCallback:(VMImagePickerGetAssetBlock)callback {
    switch (_asset.mediaType) {
        case PHAssetMediaTypeImage: {
            self.type = VMImagePickerTypeData;
            [self getJpegAssetCallback:callback];
            break;
        }
        case PHAssetMediaTypeVideo: {
            self.type = VMImagePickerTypePath;
            [self getMp4AssetCallback:callback];
            break;
        }
        default: {
            callback(self.asset, self.config, self);
            break;
        }
    }
}

@end
