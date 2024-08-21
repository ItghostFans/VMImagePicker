//
//  VMIPAssetCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CollectionControllerViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCollectionControllerViewModel;

@protocol IVMIPAssetCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
@end

@interface VMIPAssetCollectionControllerViewModel : CollectionControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAssetCollectionControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
