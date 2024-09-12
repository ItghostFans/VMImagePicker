//
//  VMIPPreviewCellViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import <ViewModel/CellViewModel+TableView.h>
#import <ViewModel/CellViewModel+CollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPPreviewCellViewModel;

@protocol IVMIPPreviewCellViewModelDelegate <ICellViewModelDelegate>
@end

@interface VMIPPreviewCellViewModel : CellViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPPreviewCellViewModelDelegate> delegate;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
