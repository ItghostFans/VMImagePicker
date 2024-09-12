//
//  VMIPPreviewCollectionControllerViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import <ViewModel/CollectionControllerViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPPreviewCollectionControllerViewModel;

@protocol IVMIPPreviewCollectionControllerViewModelDelegate <IBaseViewModelDelegate>
@end

@interface VMIPPreviewCollectionControllerViewModel : CollectionControllerViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPPreviewCollectionControllerViewModelDelegate> delegate;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
