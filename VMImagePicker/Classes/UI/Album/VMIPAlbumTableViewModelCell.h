//
//  VMIPAlbumTableViewModelCell.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import <ViewModel/TableViewModelCell.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPAlbumTableCellViewModel;

@interface VMIPAlbumTableViewModelCell : TableViewModelCell

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) VMIPAlbumTableCellViewModel *viewModel;
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
