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

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>

@interface VMIPPreviewCollectionViewModelCell () <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *previewScrollView;
@property (weak, nonatomic) UIView *previewContentView;
@property (weak, nonatomic) UIImageView *previewView;
@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation VMIPPreviewCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _requestId = PHInvalidImageRequestID;
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
    if (!viewModel) {
        if (self.requestId) {
            [PHImageManager.defaultManager cancelImageRequest:self.requestId];
            self.requestId = PHInvalidImageRequestID;
        }
        return;
    }
    @weakify(self);
    VMIPPreviewCellViewModel *cellViewModel = ((VMIPPreviewCellViewModel *)viewModel);
//    self.previewView.image = cellViewModel.assetCellViewModel.previewImage;
    self.requestId = [PHImageManager.defaultManager requestImageOfAsset:cellViewModel.assetCellViewModel.asset progressing:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
    } completion:^(BOOL finished, UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (!finished) {
            return;
        }
        @strongify(self);
        self.previewView.image = result;
        self.requestId = PHInvalidImageRequestID;
    }];
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

- (UIScrollView *)previewScrollView {
    if (!_previewScrollView) {
        UIScrollView *previewScrollView = UIScrollView.new;
        _previewScrollView = previewScrollView;
        _previewScrollView.delegate = self;
        [self.contentView addSubview:_previewScrollView];
        [_previewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _previewScrollView;
}

- (UIView *)previewContentView {
    if (!_previewContentView) {
        UIView *previewContentView = UIView.new;
        _previewContentView = previewContentView;
        _previewContentView.clipsToBounds = YES;
        _previewContentView.contentMode = UIViewContentModeScaleAspectFill;
        CGRect frame = self.viewModel.collectionSectionViewModel.collectionViewModel.collectionView.bounds;
        frame.origin = CGPointMake(0.0f, 0.0f);
        [self.previewScrollView addSubview:_previewContentView];
        _previewContentView.frame = frame;
    }
    return _previewContentView;
}

- (UIImageView *)previewView {
    if (!_previewView) {
        UIImageView *previewView = UIImageView.new;
        _previewView = previewView;
        _previewView.contentMode = UIViewContentModeScaleAspectFill;
        _previewView.clipsToBounds = YES;
        [self.previewContentView addSubview:_previewView];
        [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _previewView;
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.previewContentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPPreviewCollectionCellViewModel *)viewModel {
    return *size;
}

@end
