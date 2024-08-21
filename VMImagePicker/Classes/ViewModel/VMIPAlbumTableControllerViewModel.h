//
//  VMIPAlbumTableControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/TableControllerViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAlbumTableControllerViewModel;

@protocol IVMIPAlbumTableControllerViewModelDelegate <IBaseViewModelDelegate>
@end

@interface VMIPAlbumTableControllerViewModel : TableControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPAlbumTableControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
