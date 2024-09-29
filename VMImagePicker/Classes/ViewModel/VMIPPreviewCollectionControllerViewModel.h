//
//  VMIPPreviewCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import <ViewModel/CollectionControllerViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class VMIPPreviewCollectionControllerViewModel;
@class VMIPAssetCellViewModel;

@protocol IVMIPPreviewCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
@optional
- (void)viewModel:(VMIPPreviewCollectionControllerViewModel *)viewModel didSelectedAssets:(NSArray<__kindof PHAsset *> *)assets;
@end

@interface VMIPPreviewCollectionControllerViewModel : CollectionControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPPreviewCollectionControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (weak, nonatomic) NSArray<__kindof VMIPAssetCellViewModel *> *selectedCellViewModels;    // 已经选中的资源

@end

NS_ASSUME_NONNULL_END
