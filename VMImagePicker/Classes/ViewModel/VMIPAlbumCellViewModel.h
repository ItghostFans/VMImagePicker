//
//  VMIPAlbumCellViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/CellViewModel+TableView.h>
#import <ViewModel/CellViewModel+CollectionView.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAlbumCellViewModel;

@protocol IVMIPAlbumCellViewModelDelegate <ICellViewModelDelegate>
@end

@interface VMIPAlbumCellViewModel : CellViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAlbumCellViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (strong, nonatomic, readonly) PHAssetCollection *assetCollection;
@property (strong, nonatomic, readonly, nonnull) NSString *name;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection;

@end

NS_ASSUME_NONNULL_END
