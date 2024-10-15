//
//  VMImagePickerQueue.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/15.
//

#import "VMImagePickerQueue.h"
#import "VMImagePicker.h"

#import <Photos/PHAsset.h>

@interface VMImagePickerQueue ()
@property (strong, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) NSArray<__kindof VMImagePicker *> *imagePickers;
@end

@implementation VMImagePickerQueue

- (void)dealloc {
}

- (instancetype)initWithImagePickers:(NSArray<__kindof VMImagePicker *> *)imagePickers {
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.image.picker.queue", DISPATCH_QUEUE_SERIAL);
        _imagePickers = imagePickers;
    }
    return self;
}

- (void)enumerateAssetsUsingBlock:(VMImagePickerGetAssetBlock _Nonnull)block {
    dispatch_group_t pickerGroup = dispatch_group_create();
    for (VMImagePicker *imagePicker in self.imagePickers) {
        dispatch_group_enter(pickerGroup);
        dispatch_async(_queue, ^{
            // 任务排队执行Asset数据。
            [imagePicker getAssetCallback:^(PHAsset * _Nonnull asset, VMImagePickerConfig * _Nonnull config, VMImagePicker * _Nonnull imagePicker) {
                block(asset, config, imagePicker);
                dispatch_group_leave(pickerGroup);
            }];
        });
    }
    dispatch_group_notify(pickerGroup, dispatch_get_main_queue(), ^{
        self.imagePickers = nil;
    });
}

@end
