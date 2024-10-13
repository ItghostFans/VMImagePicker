//
//  VMImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/2.
//

#import "VMImagePicker.h"
#import "VMImagePickerConfig.h"

@interface VMImagePicker ()
@property (strong, nonatomic) PHAsset *asset;
@property (assign, nonatomic) VMImagePickerConfig *config;
@end

@implementation VMImagePicker

- (instancetype)initWithAsset:(PHAsset *)asset config:(VMImagePickerConfig *)config {
    if (self = [super init]) {
        _asset = asset;
        _config = config;
    }
    return self;
}

- (void)getAssetCallback:(void (^)(PHAsset *asset, VMImagePickerConfig *config, id object, NSData *data))callback {
    if (self.config.original) {
        
    } else {
        
    }
}

@end
