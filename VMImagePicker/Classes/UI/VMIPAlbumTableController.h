//
//  VMIPAlbumTableController.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/TableController.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;
@class VMIPAlbumTableControllerViewModel;

@interface VMIPAlbumTableController : TableController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic, nullable) VMIPAlbumTableControllerViewModel *viewModel;
#pragma clang diagnostic pop

@property (weak, nonatomic, readonly) VMImagePickerStyle *style;

@end

NS_ASSUME_NONNULL_END
