//
//  VMIPVideoEditViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoEditViewModel.h"
#import "VMIPVideoFrameCollectionControllerViewModel.h"

#import <AVFoundation/Avasset.h>
#import <Photos/PHImageManager.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/SectionViewModel.h>

@interface VMIPVideoEditViewModel () <IVMIPVideoFrameCollectionControllerViewModelDelegate>
@property (assign, nonatomic) PHImageRequestID requestId;
@property (strong, nonatomic) VMIPVideoFrameCollectionControllerViewModel *frameViewModel;
@end

@implementation VMIPVideoEditViewModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [self init]) {
        _requestId = PHInvalidImageRequestID;
        _asset = asset;
        CollectionViewModel *collectionViewModel = CollectionViewModel.new;
        SectionViewModel *sectionViewModel = SectionViewModel.new;
        [collectionViewModel.sectionViewModels addViewModel:sectionViewModel];
        _frameViewModel = [[VMIPVideoFrameCollectionControllerViewModel alloc] initWithCollectionViewModel:collectionViewModel];
        _frameViewModel.delegate = self;
    }
    return self;
}

- (void)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
     completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion {
    @weakify(self);
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
}

#pragma mark - IVMIPVideoFrameCollectionControllerViewModelDelegate

- (PHAsset *)assetOfViewModel:(VMIPVideoFrameCollectionControllerViewModel *)viewModel {
    return _asset;
}

@end
