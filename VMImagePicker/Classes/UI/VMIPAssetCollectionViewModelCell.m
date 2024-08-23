//
//  VMIPAssetCollectionViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionViewModelCell.h"
#import "VMIPAssetCollectionCellViewModel.h"
#import "VMIPAssetCellViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface VMIPAssetCollectionViewModelCell ()
@property (weak, nonatomic) UIImageView *previewImageView;
@property (strong, nonatomic, nullable) RACCompoundDisposable *disposableBag;
@end

@implementation VMIPAssetCollectionViewModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:((self.hash & 0x00FF0000) >> 16) / 255.0f
                                               green:((self.hash & 0x0000FF00) >> 8)  / 255.0f
                                                blue:((self.hash & 0x000000FF) >> 0)  / 255.0f
                                               alpha:1.0f];
    }
    return self;
}

- (void)setViewModel:(VMIPAssetCollectionCellViewModel *)viewModel {
    @weakify(self);
    if (!viewModel) {
        [self.disposableBag dispose];
        self.disposableBag = nil;
    }
    BOOL same = self.viewModel == viewModel;
    [super setViewModel:viewModel];
    if (same) {
        // 防止这里不必要的UI刷新。
        return;
    }
    self.disposableBag = RACCompoundDisposable.new;
    [self.disposableBag addDisposable:
     [[RACObserve(((VMIPAssetCellViewModel *)viewModel), previewImage) takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.previewImageView.image = x;
     }]];;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

- (UIImageView *)previewImageView {
    if (!_previewImageView) {
        UIImageView *previewImageView = UIImageView.new;
        _previewImageView = previewImageView;
        _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView.clipsToBounds = YES;
        [self.contentView addSubview:_previewImageView];
        [_previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _previewImageView;
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPAssetCollectionCellViewModel *)viewModel {
    return CGSizeZero;
}

@end
