//
//  VMIPVideoEditViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <ViewModel/BaseViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class AVPlayerItem;
@class VMIPVideoFrameCollectionControllerViewModel;

@interface VMIPVideoEditViewModel : BaseViewModel

@property (strong, nonatomic, readonly) VMIPVideoFrameCollectionControllerViewModel *frameViewModel;

@property (weak, nonatomic, readonly) PHAsset *asset;

- (instancetype)initWithAsset:(PHAsset *)asset;

- (void)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
     completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion;

@end

NS_ASSUME_NONNULL_END
