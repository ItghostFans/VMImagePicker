//
//  VMIPAssetCollectionController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CollectionController.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCollectionControllerViewModel;

@interface VMIPAssetCollectionController : CollectionController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic, nullable) VMIPAssetCollectionControllerViewModel *viewModel;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
