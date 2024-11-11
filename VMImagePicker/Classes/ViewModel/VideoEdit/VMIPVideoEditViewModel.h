//
//  VMIPVideoEditViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <ViewModel/BaseViewModel.h>

#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class AVPlayerItem;
@class VMIPVideoFrameCollectionControllerViewModel;
@class VMIPVideoViewModel;

@interface VMIPVideoEditViewModel : BaseViewModel

@property (strong, nonatomic, readonly) VMIPVideoFrameCollectionControllerViewModel *frameViewModel;
@property (strong, nonatomic, readonly) VMIPVideoViewModel *videoViewModel;

@property (weak, nonatomic, readonly) PHAsset *asset;

- (instancetype)initWithAsset:(PHAsset *)asset;

- (PHImageRequestID)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
                 completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion;

@end

NS_ASSUME_NONNULL_END
