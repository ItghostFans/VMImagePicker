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
#import <ViewModel/CollectionViewModel.h>

@interface VMIPPreviewCollectionViewModelCell () <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *previewScrollView;
@property (weak, nonatomic) UIView *previewContentView;
@property (weak, nonatomic) UIImageView *previewView;
@end

@implementation VMIPPreviewCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    self.previewView.image = ((VMIPPreviewCellViewModel *)viewModel).assetCellViewModel.previewImage;
    self.previewScrollView.contentSize = self.previewContentView.frame.size;
//    [PHImageManager.defaultManager requestImageOfAsset:<#(nonnull PHAsset *)#> size:<#(CGSize)#> contentMode:<#(PHImageContentMode)#> completion:<#^(BOOL finished, BOOL inCloud, UIImage * _Nullable result, NSDictionary * _Nullable info)completion#>];
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
