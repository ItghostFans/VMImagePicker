//
//  VMIPVideoViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/27.
//

#import "VMIPVideoViewModel.h"

#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoViewModel ()
@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation VMIPVideoViewModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [self init]) {
        _requestId = PHInvalidImageRequestID;
        _asset = asset;
    }
    return self;
}

- (PHImageRequestID)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
     completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion {
    @weakify(self);
    if (_requestId != PHInvalidImageRequestID) {
        [PHImageManager.defaultManager cancelImageRequest:_requestId];
        _requestId = PHInvalidImageRequestID;
    }
    PHVideoRequestOptions *option = PHVideoRequestOptions.new;
    option.networkAccessAllowed = YES;
    option.progressHandler = loading;
    _requestId = [PHImageManager.defaultManager requestPlayerItemForVideo:_asset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        @strongify(self);
        if (self.requestId != [info[PHImageResultRequestIDKey] intValue]) {
            return;
        }
        NSError *error = info[PHImageErrorKey];
        if (!error) {
            if ([info[PHImageCancelledKey] boolValue]) {
                error = [NSError errorWithDomain:@"User Cancel Play Video!" code:0 userInfo:nil];
            } else {
            }
        }
        completion(error, playerItem);
        self.requestId = PHInvalidImageRequestID;
    }];
    return _requestId;
}

@end
