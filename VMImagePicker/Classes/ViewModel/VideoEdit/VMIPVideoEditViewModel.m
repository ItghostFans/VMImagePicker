//
//  VMIPVideoEditViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoEditViewModel.h"
#import "VMIPVideoFrameCollectionControllerViewModel.h"
#import "VMIPVideoViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/SectionViewModel.h>

@interface VMIPVideoEditViewModel () <IVMIPVideoFrameCollectionControllerViewModelDelegate>
@property (strong, nonatomic) VMIPVideoFrameCollectionControllerViewModel *frameViewModel;
@property (strong, nonatomic) VMIPVideoViewModel *videoViewModel;
@end

@implementation VMIPVideoEditViewModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [self init]) {
        _asset = asset;
        _videoViewModel = [[VMIPVideoViewModel alloc] initWithAsset:_asset];
        CollectionViewModel *collectionViewModel = CollectionViewModel.new;
        SectionViewModel *sectionViewModel = SectionViewModel.new;
        [collectionViewModel.sectionViewModels addViewModel:sectionViewModel];
        _frameViewModel = [[VMIPVideoFrameCollectionControllerViewModel alloc] initWithCollectionViewModel:collectionViewModel];
        _frameViewModel.delegate = self;
    }
    return self;
}

- (PHImageRequestID)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
                 completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion {
    return [_videoViewModel loading:loading completion:completion];
}

#pragma mark - IVMIPVideoFrameCollectionControllerViewModelDelegate

- (PHAsset *)assetOfViewModel:(VMIPVideoFrameCollectionControllerViewModel *)viewModel {
    return _asset;
}

@end
