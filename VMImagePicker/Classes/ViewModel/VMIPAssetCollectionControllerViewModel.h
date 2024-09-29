//
//  VMIPAssetCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CollectionControllerViewModel.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class VMIPAssetCellViewModel;
@class VMIPAssetCollectionControllerViewModel;
@class SectionViewModel;

@protocol IVMIPAssetCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
@optional
- (void)viewModel:(VMIPAssetCollectionControllerViewModel *)viewModel didSelectedAssets:(NSArray<__kindof PHAsset *> *)assets;
@end

@interface VMIPAssetCollectionControllerViewModel : CollectionControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAssetCollectionControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (strong, nonatomic, readonly) PHAssetCollection *assetCollection;
@property (strong, nonatomic, readonly) PHFetchOptions *options;
@property (strong, nonatomic, readonly, nonnull) NSString *name;
@property (weak, nonatomic, readonly) SectionViewModel *sectionViewModel;

@property (strong, nonatomic, readonly) NSArray<__kindof VMIPAssetCellViewModel *> *selectedCellViewModels;    // 已经选中的资源

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection
                                options:(PHFetchOptions * _Nullable)options;

@end

NS_ASSUME_NONNULL_END
