//
//  VMIPVideoFrameCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <ViewModel/CollectionControllerViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

@class VMIPVideoFrameCollectionControllerViewModel;

@protocol IVMIPVideoFrameCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
- (PHAsset *)assetOfViewModel:(VMIPVideoFrameCollectionControllerViewModel *)viewModel;
@end

@interface VMIPVideoFrameCollectionControllerViewModel : CollectionControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPVideoFrameCollectionControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (assign, nonatomic) NSTimeInterval frameInteval;      // Default 1 second.

- (void)loadVideoCompletion:(void (^ _Nonnull)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
