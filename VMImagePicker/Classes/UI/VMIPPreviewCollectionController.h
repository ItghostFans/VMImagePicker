//
//  VMIPPreviewCollectionController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import <ViewModel/CollectionController.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPPreviewCollectionControllerViewModel;

@interface VMIPPreviewCollectionController : CollectionController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic, nullable) VMIPPreviewCollectionControllerViewModel *viewModel;
#pragma clang diagnostic pop

@property (strong, nonatomic, nullable) NSIndexPath *previewIndexPath;

@end

NS_ASSUME_NONNULL_END
