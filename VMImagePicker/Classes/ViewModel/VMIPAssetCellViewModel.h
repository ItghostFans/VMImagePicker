//
//  VMIPAssetCellViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CellViewModel+TableView.h>
#import <ViewModel/CellViewModel+CollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCellViewModel;

@protocol IVMIPAssetCellViewModelDelegate <ICellViewModelDelegate>
@end

@interface VMIPAssetCellViewModel : CellViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAssetCellViewModelDelegate> delegate;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
