//
//  VMIPAssetCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CollectionControllerViewModel.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCollectionControllerViewModel;
@class SectionViewModel;

@protocol IVMIPAssetCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
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
@property (strong, nonatomic, readonly) NSArray *selectedCellViewModels;
@property (weak, nonatomic, readonly) SectionViewModel *sectionViewModel;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection
                                options:(PHFetchOptions * _Nullable)options;

@end

NS_ASSUME_NONNULL_END
