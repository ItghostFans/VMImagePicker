//
//  VMIPPreviewCollectionViewModelCell.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import <ViewModel/CollectionViewModelCell.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPPreviewCollectionCellViewModel;

@interface VMIPPreviewCollectionViewModelCell : CollectionViewModelCell

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) VMIPPreviewCollectionCellViewModel *viewModel;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
