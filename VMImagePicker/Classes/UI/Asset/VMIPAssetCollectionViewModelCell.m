//
//  VMIPAssetCollectionViewModelCell.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionViewModelCell.h"
#import "VMIPAssetCollectionCellViewModel.h"
#import "VMIPAssetCellViewModel.h"
#import "VMIPAssetCollectionController.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <VMLocalization/VMLocalization.h>

@interface VMIPAssetCellViewModel ()
@property (assign, nonatomic) BOOL selected;
@end

@interface VMIPAssetCollectionViewModelCell ()
@property (weak, nonatomic) VMImagePickerStyle *vmipStyle;
@property (weak, nonatomic) VMImagePickerConfig *vmipConfig;
@property (weak, nonatomic) UIImageView *previewImageView;
@property (weak, nonatomic) UIButton *selectedButton;
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
    }]];
    [self.disposableBag addDisposable:
     [[RACObserve(((VMIPAssetCellViewModel *)viewModel), selected) takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.selectedButton.selected = [x boolValue];
    }]];
    [self.disposableBag addDisposable:
     [[RACObserve(((VMIPAssetCellViewModel *)viewModel).selectedDelegate, selectedCellViewModels) takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSUInteger index = [x indexOfObject:self.viewModel];
        [self.selectedButton setTitle:index == NSNotFound ? @"" : @(index + 1).stringValue forState:(UIControlStateNormal)];
    }]];
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

- (VMImagePickerStyle *)vmipStyle {
    if (!_vmipStyle) {
        VMIPAssetCollectionController *controller = (VMIPAssetCollectionController *)self;
        do {
            controller = controller.nextResponder;
        } while ([controller isKindOfClass:UIView.class]);
        _vmipStyle = controller.style;
    }
    return _vmipStyle;
}

- (VMImagePickerConfig *)vmipConfig {
    if (!_vmipConfig) {
        VMIPAssetCollectionController *controller = (VMIPAssetCollectionController *)self;
        do {
            controller = controller.nextResponder;
        } while ([controller isKindOfClass:UIView.class]);
        _vmipConfig = controller.config;
    }
    return _vmipConfig;
}

- (UIImageView *)previewImageView {
    if (_previewImageView) {
        return _previewImageView;
    }
    UIImageView *previewImageView = UIImageView.new;
    _previewImageView = previewImageView;
    _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _previewImageView.clipsToBounds = YES;
    [self.contentView addSubview:_previewImageView];
    [_previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.directionalEdges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return previewImageView;
}

- (UIButton *)selectedButton {
    if (_selectedButton) {
        return _selectedButton;
    }
    UIButton *selectedButton = UIButton.new;
    _selectedButton = selectedButton;
    [_selectedButton setBackgroundImage:[self.vmipStyle imageWithCellThemeImages:self.vmipStyle.assetSelectedImages selected:NO] forState:(UIControlStateNormal)];
    [_selectedButton setBackgroundImage:[self.vmipStyle imageWithCellThemeImages:self.vmipStyle.assetSelectedImages selected:YES] forState:(UIControlStateSelected)];
    [_selectedButton setTitleColor:[self.vmipStyle colorWithCellThemeColors:self.vmipStyle.assetSelectedTitleColors selected:NO] forState:(UIControlStateNormal)];
    [_selectedButton setTitleColor:[self.vmipStyle colorWithCellThemeColors:self.vmipStyle.assetSelectedTitleColors selected:YES] forState:(UIControlStateSelected)];
    _selectedButton.titleLabel.font = [self.vmipStyle fontWithCellFonts:self.vmipStyle.assetSelectedTitleFonts selected:NO];
    [self.contentView addSubview:_selectedButton];
    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
        make.trailing.equalTo(self.contentView).mas_equalTo(-6.0f);
        make.top.equalTo(self.contentView).mas_equalTo(6.0f);
    }];
    [_selectedButton addTarget:self action:@selector(onSelectedClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return selectedButton;
}

#pragma mark - Actions

- (void)onSelectedClicked:(id)sender {
    VMIPAssetCellViewModel *viewModel = (VMIPAssetCellViewModel *)self.viewModel;
    if (viewModel.selected) {
        viewModel.selected = NO;
    } else
    if (!viewModel.selected && viewModel.selectedDelegate.selectedCellViewModels.count < self.vmipConfig.count) {
        viewModel.selected = YES;
    }
}

#pragma mark - CollectionViewModelCell

+ (CGSize)cellSizeForSize:(CGSize *)size viewModel:(VMIPAssetCollectionCellViewModel *)viewModel {
    return CGSizeZero;
}

@end
