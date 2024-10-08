//
//  VMIPAssetCellViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CellViewModel+TableView.h>
#import <ViewModel/CellViewModel+CollectionView.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAssetCellViewModel;

@protocol IVMIPAssetCellViewModelDelegate <ICellViewModelDelegate>
@end

@protocol IVMIPAssetCellViewModelSelectedDelegate <NSObject>

@property (strong, nonatomic, readonly) NSArray *selectedCellViewModels;

@end

@interface VMIPAssetCellViewModel : CellViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAssetCellViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (weak, nonatomic, nullable) id<IVMIPAssetCellViewModelSelectedDelegate> selectedDelegate;

@property (strong, nonatomic, readonly) PHAsset *asset;
@property (assign, nonatomic, readonly) BOOL inCloud;
@property (assign, nonatomic, readonly) BOOL selected;
@property (strong, nonatomic, readonly) UIImage *previewImage;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
