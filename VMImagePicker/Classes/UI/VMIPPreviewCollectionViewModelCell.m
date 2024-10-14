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

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>

@interface VMIPPreviewCollectionViewModelCell () <UIScrollViewDelegate>
@property (weak, nonatomic) VMImagePickerStyle *vmipStyle;
@property (weak, nonatomic) VMImagePickerConfig *vmipConfig;
@property (weak, nonatomic) UIScrollView *previewScrollView;
@property (weak, nonatomic) UIView *previewContentView;
@property (weak, nonatomic) UIImageView *previewView;
@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation VMIPPreviewCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _requestId = PHInvalidImageRequestID;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:doubleTap];
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
        return;
    }
    @weakify(self);
    VMIPPreviewCellViewModel *cellViewModel = ((VMIPPreviewCellViewModel *)viewModel);
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
        make.edges.mas_equalTo(UIEdgeInsetsZero);
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
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return previewView;
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
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPPreviewCollectionCellViewModel *)viewModel {
    return *size;
}

@end
