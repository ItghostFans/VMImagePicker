//
//  VMIPVideoFrameCollectionController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <ViewModel/CollectionController.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPVideoFrameCollectionControllerViewModel;

@interface VMIPVideoFrameCollectionController : CollectionController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic, nullable) VMIPVideoFrameCollectionControllerViewModel *viewModel;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
