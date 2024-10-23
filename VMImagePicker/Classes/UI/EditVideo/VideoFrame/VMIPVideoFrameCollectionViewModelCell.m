//
//  VMIPVideoFrameCollectionViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoFrameCollectionViewModelCell.h"
#import "VMIPVideoFrameCollectionCellViewModel.h"
#import "VMIPVideoFrameCellViewModel+Private.h"

#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVTime.h>

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoFrameCollectionViewModelCell ()
@property (weak, nonatomic) UIImageView *frameImageView;
@end

@implementation VMIPVideoFrameCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:((self.hash & 0x00FF0000) >> 16) / 255.0f
                                               green:((self.hash & 0x0000FF00) >> 8)  / 255.0f
                                                blue:((self.hash & 0x000000FF) >> 0)  / 255.0f
                                               alpha:1.0f];
    }
    return self;
}

- (void)setViewModel:(VMIPVideoFrameCollectionCellViewModel *)viewModel {
    @weakify(self);
    BOOL same = self.viewModel == viewModel;
    [super setViewModel:viewModel];
    if (same) {
        // 防止这里不必要的UI刷新。
        return;
    }
    VMIPVideoFrameCellViewModel *cellViewModel = viewModel;
    NSValue *frameTime = [NSValue valueWithCMTime:cellViewModel.frameTime];
    [cellViewModel.imageGenerator generateCGImagesAsynchronouslyForTimes:@[frameTime] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        @strongify(self);
        if (!image) {
            NSAssert(!error, @"Generate Image Error %@", error);
            return;
        }
        UIImage *frameImage = [[UIImage alloc] initWithCGImage:image];
        RACTuple *tuple = [RACTuple tupleWithObjects:frameImage, [NSValue valueWithCMTime:requestedTime], nil];
        if (NSThread.isMainThread) {
            [self showFrameImageTuple:tuple];
        } else {
            [self performSelectorOnMainThread:@selector(showFrameImageTuple:) withObject:tuple waitUntilDone:NO];
        }
    }];
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

- (void)showFrameImageTuple:(RACTuple *)tuple {
    RACTupleUnpack(UIImage *frameImage, NSValue *requestedTime) = tuple;
    VMIPVideoFrameCellViewModel *cellViewModel = self.viewModel;
    if (CMTimeCompare(requestedTime.CMTimeValue, cellViewModel.frameTime) != 0) {
        return;
    }
    self.frameImageView.image = frameImage;
}

#pragma mark - Getter

- (UIImageView *)frameImageView {
    if (_frameImageView) {
        return _frameImageView;
    }
    UIImageView *frameImageView = UIImageView.new;
    _frameImageView = frameImageView;
    [self.contentView addSubview:_frameImageView];
    [_frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    return frameImageView;
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPVideoFrameCollectionCellViewModel *)viewModel {
    VMIPVideoFrameCellViewModel *cellViewModel = viewModel;
    return cellViewModel.imageGenerator.maximumSize;
}

@end
