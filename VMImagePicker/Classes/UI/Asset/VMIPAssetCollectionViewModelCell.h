//
//  VMIPAssetCollectionViewModelCell.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CollectionViewModelCell.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCollectionCellViewModel;

@interface VMIPAssetCollectionViewModelCell : CollectionViewModelCell

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) VMIPAssetCollectionCellViewModel *viewModel;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
