//
//  VMIPVideoFrameCellViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import <ViewModel/CellViewModel+TableView.h>
#import <ViewModel/CellViewModel+CollectionView.h>

#import <CoreMedia/CMTime.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAssetImageGenerator;

@class VMIPVideoFrameCellViewModel;

@protocol IVMIPVideoFrameCellViewModelDelegate <ICellViewModelDelegate>
@end

@interface VMIPVideoFrameCellViewModel : CellViewModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic, nullable) id<IVMIPVideoFrameCellViewModelDelegate> delegate;
#pragma clang diagnostic pop

@property (assign, nonatomic) CMTime frameTime;
@property (weak, nonatomic, nullable) AVAssetImageGenerator *imageGenerator;
@property (strong, nonatomic, readonly, nullable) UIImage *frameImage;
@property (assign, nonatomic) NSInteger videoCropFrameCount;
//@property (assign, nonatomic) CGSize prefferredSize;

@end

NS_ASSUME_NONNULL_END
