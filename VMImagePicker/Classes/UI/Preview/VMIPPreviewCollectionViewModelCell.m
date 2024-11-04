//
//  VMIPPreviewCollectionViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import "VMIPPreviewCollectionViewModelCell.h"
#import "VMIPPreviewCollectionCellViewModel.h"
#import "PHImageManager+ImagePicker.h"
#import "VMIPPreviewCellViewModel.h"
#import "VMIPAssetCellViewModel.h"
#import "VMIPPreviewCollectionController.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"
#import "VMIPVideoPlayer.h"
#import "VMIPVideoHandler.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>
#import <VMLocalization/VMLocalization.h>

@interface VMIPPreviewCollectionViewModelCell () <UIScrollViewDelegate>
@property (weak, nonatomic) VMImagePickerStyle *vmipStyle;
@property (weak, nonatomic) VMImagePickerConfig *vmipConfig;
@property (weak, nonatomic) UIView *actionView;
@property (weak, nonatomic) UIScrollView *previewScrollView;
@property (weak, nonatomic) UIView *previewContentView;
@property (weak, nonatomic) UIImageView *previewView;
@property (assign, nonatomic) PHImageRequestID requestId;
@property (weak, nonatomic) VMIPVideoPlayer *videoPlayer;
@property (strong, nonatomic) VMIPVideoHandler *videoPlayHandler;
@end

@implementation VMIPPreviewCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _requestId = PHInvalidImageRequestID;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self.actionView addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self.actionView addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)setViewModel:(VMIPPreviewCollectionCellViewModel *)viewModel {
    BOOL same = self.viewModel == viewModel;
    [super setViewModel:viewModel];
    if (same) {
        // 防止这里不必要的UI刷新。
        return;
    }
    if (self.requestId != PHInvalidImageRequestID) {
        [PHImageManager.defaultManager cancelImageRequest:self.requestId];
        self.requestId = PHInvalidImageRequestID;
    }
    if (!viewModel) {
        [self.videoPlayer pause];
        [self.videoPlayer removeFromSuperview];
        return;
    }
    @weakify(self);
    VMIPPreviewCellViewModel *cellViewModel = ((VMIPPreviewCellViewModel *)viewModel);
    [[[cellViewModel rac_signalForSelector:@selector(pauseVideoIfNeed)] takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.videoPlayer pause];
    }];
    self.previewScrollView.hidden = cellViewModel.assetCellViewModel.asset.mediaType != PHAssetMediaTypeImage;
    self.videoPlayer.hidden = cellViewModel.assetCellViewModel.asset.mediaType != PHAssetMediaTypeVideo;
    switch (cellViewModel.assetCellViewModel.asset.mediaType) {
        case PHAssetMediaTypeImage: {
            self.previewView.image = cellViewModel.assetCellViewModel.previewImage;
            [self.previewScrollView setZoomScale:self.previewScrollView.minimumZoomScale animated:NO];
            [self updateContentFrame];
            self.requestId = [PHImageManager.defaultManager requestImageOfAsset:cellViewModel.assetCellViewModel.asset progressing:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            } completion:^(BOOL finished, UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (!finished) {
                    return;
                }
                @strongify(self);
                if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
                    return;
                }
                self.previewView.image = result;
                self.requestId = PHInvalidImageRequestID;
            }];
            break;
        }
        case PHAssetMediaTypeVideo: {
            self.requestId = [cellViewModel loading:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            } completion:^(NSError * _Nonnull error, AVPlayerItem * _Nonnull playerItem) {
                @strongify(self);
                [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
//                [RACObserve(self.videoPlayer, time) subscribeNext:^(id  _Nullable x) {
//                    @strongify(self);
//                    if (self.videoPlayer.duration == 0.0f) {
//                        return;
//                    }
//                    NSTimeInterval time = [x doubleValue];
//                    CGFloat progress = time / self.videoPlayer.duration;
//                    CGFloat offset = self.cropView.barWidth + (self.timeIndicatorOffsetWidth * progress);
//                    [self.timeIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.leading.equalTo(self.cropView).offset(offset);
//                    }];
//                    [self.view layoutIfNeeded];
//                }];
                self.requestId = PHInvalidImageRequestID;
            }];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

- (void)updateContentFrame {
    VMIPPreviewCellViewModel *viewModel = self.viewModel;
    CGSize viewSize = self.viewModel.collectionSectionViewModel.collectionViewModel.collectionView.bounds.size;
    CGSize imageSize = CGSizeMake(viewModel.assetCellViewModel.asset.pixelWidth, viewModel.assetCellViewModel.asset.pixelHeight);
    CGFloat hFactor = viewSize.height / imageSize.height;
    CGFloat wFactor = viewSize.width / imageSize.width;
    CGFloat factor = hFactor;
    if (wFactor < hFactor) {
        factor = wFactor;
    }
    CGRect frame = CGRectMake(0.0f, 0.0f, imageSize.width * factor, imageSize.height * factor);
    frame = CGRectOffset(frame, viewSize.width / 2 - CGRectGetMidX(frame), viewSize.height / 2 - CGRectGetMidY(frame));
    self.previewContentView.frame = frame;
    self.previewScrollView.maximumZoomScale = 1.0f / factor;
    // 以下保证放大后，能铺满整个View，否则可能会存在上下/左右留白。
    if (imageSize.height < viewSize.height) {
        self.previewScrollView.maximumZoomScale *= viewSize.height / imageSize.height;
    } else
    if (imageSize.width < viewSize.width) {
        self.previewScrollView.maximumZoomScale *= viewSize.width / imageSize.width;
    }
}

#pragma mark - Getter

- (VMImagePickerStyle *)vmipStyle {
    if (!_vmipStyle) {
        VMIPPreviewCollectionController *controller = (VMIPPreviewCollectionController *)self;
        do {
            controller = controller.nextResponder;
        } while ([controller isKindOfClass:UIView.class]);
        _vmipStyle = controller.style;
    }
    return _vmipStyle;
}

- (VMImagePickerConfig *)vmipConfig {
    if (!_vmipConfig) {
        VMIPPreviewCollectionController *controller = (VMIPPreviewCollectionController *)self;
        do {
            controller = controller.nextResponder;
        } while ([controller isKindOfClass:UIView.class]);
        _vmipConfig = controller.config;
    }
    return _vmipConfig;
}

#pragma mark - Getter Image

- (UIView *)actionView {
    if (_actionView) {
        return _actionView;
    }
    UIView *actionView = UIView.new;
    _actionView = actionView;
    [self.contentView addSubview:_actionView];
    [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return actionView;
}

- (UIScrollView *)previewScrollView {
    if (_previewScrollView) {
        return _previewScrollView;
    }
    UIScrollView *previewScrollView = UIScrollView.new;
    _previewScrollView = previewScrollView;
    
    _previewScrollView.scrollsToTop = NO;
    _previewScrollView.showsHorizontalScrollIndicator = NO;
    _previewScrollView.showsVerticalScrollIndicator = YES;
    _previewScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _previewScrollView.delaysContentTouches = NO;
    _previewScrollView.canCancelContentTouches = YES;
    _previewScrollView.alwaysBounceVertical = NO;
    _previewScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    _previewScrollView.delegate = self;
    [self.contentView addSubview:_previewScrollView];
    [_previewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.directionalEdges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return previewScrollView;
}

- (UIView *)previewContentView {
    if (_previewContentView) {
        return _previewContentView;
    }
    UIView *previewContentView = UIView.new;
    _previewContentView = previewContentView;
    _previewContentView.clipsToBounds = YES;
    _previewContentView.contentMode = UIViewContentModeScaleAspectFill;
    [self.previewScrollView addSubview:_previewContentView];
    return previewContentView;
}

- (UIImageView *)previewView {
    if (_previewView) {
        return _previewView;
    }
    UIImageView *previewView = UIImageView.new;
    _previewView = previewView;
    _previewView.contentMode = UIViewContentModeScaleAspectFill;
    _previewView.clipsToBounds = YES;
    [self.previewContentView addSubview:_previewView];
    [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.directionalEdges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return previewView;
}

#pragma mark - Getter Video

- (VMIPVideoPlayer *)videoPlayer {
    if (_videoPlayer) {
        return _videoPlayer;
    }
    VMIPVideoPlayer *videoPlayer = VMIPVideoPlayer.new;
    _videoPlayer = videoPlayer;
    [self.contentView addSubview:_videoPlayer];
    [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.directionalEdges.equalTo(self.contentView);
    }];
    _videoPlayHandler = [[VMIPVideoHandler alloc] initWithVideoPlayer:_videoPlayer style:self.vmipStyle];
    return videoPlayer;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.previewContentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 调整中心点，以便能够正确移动到边界。
    CGFloat viewWidth = CGRectGetWidth(scrollView.frame);
    CGFloat viewHeight = CGRectGetHeight(scrollView.frame);
    CGFloat offsetX = (viewWidth > scrollView.contentSize.width) ? ((viewWidth - scrollView.contentSize.width) / 2) : 0.0f;
    CGFloat offsetY = (viewHeight > scrollView.contentSize.height) ? ((viewHeight - scrollView.contentSize.height) / 2) : 0.0f;
    self.previewContentView.center = CGPointMake((scrollView.contentSize.width / 2) + offsetX, (scrollView.contentSize.height / 2) + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

#pragma mark - Actions

- (void)singleTap:(UITapGestureRecognizer *)tap {
    VMIPPreviewCollectionController *previewCollectionController = self;
    do {
        previewCollectionController = previewCollectionController.nextResponder;
    } while (![previewCollectionController isKindOfClass:VMIPPreviewCollectionController.class]);
    previewCollectionController.navigationController.navigationBarHidden = !previewCollectionController.navigationController.navigationBarHidden;
    previewCollectionController.navigationController.toolbarHidden = !previewCollectionController.navigationController.toolbarHidden;
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    VMIPPreviewCellViewModel *cellViewModel = ((VMIPPreviewCellViewModel *)self.viewModel);
    switch (cellViewModel.assetCellViewModel.asset.mediaType) {
        case PHAssetMediaTypeImage: {
            if (self.previewScrollView.zoomScale > self.previewScrollView.minimumZoomScale) {
                self.previewScrollView.contentInset = UIEdgeInsetsZero;
                [self.previewScrollView setZoomScale:self.previewScrollView.minimumZoomScale animated:YES];
            } else {
                CGSize viewSize = self.viewModel.collectionSectionViewModel.collectionViewModel.collectionView.bounds.size;
                CGPoint touchPoint = [tap locationInView:self.previewView];
                CGFloat zoomScale = MAX(self.previewScrollView.maximumZoomScale, 2.0f);
                CGFloat zoomWidth = viewSize.width / zoomScale;
                CGFloat zoomHeight = viewSize.height / zoomScale;
                [self.previewScrollView zoomToRect:CGRectMake(touchPoint.x - zoomWidth / 2, touchPoint.y - zoomHeight / 2, zoomWidth, zoomHeight) animated:YES];
            }
            break;
        }
        case PHAssetMediaTypeVideo: {
            if ([self.videoPlayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
                self.videoPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                self.videoPlayer.userInteractionEnabled = NO;
            } else
            if ([self.videoPlayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                self.videoPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
                self.videoPlayer.userInteractionEnabled = YES;
            }
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPPreviewCollectionCellViewModel *)viewModel {
    return *size;
}

@end
