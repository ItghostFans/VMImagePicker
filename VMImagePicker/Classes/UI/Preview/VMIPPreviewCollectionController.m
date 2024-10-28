//
//  VMIPPreviewCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import "VMIPPreviewCollectionController.h"
#import "VMIPPreviewCollectionControllerViewModel.h"
#import "VMIPPreviewCellViewModel.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"
#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerController.h"
#import "VMIPPreviewToolBarView.h"
#import "VMImagePickerConfig.h"
#import "VMIPAssetCellViewModel.h"
#import "VMIPVideoEditController.h"
#import "VMIPVideoEditViewModel.h"

#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/ColumnRowFlowLayout.h>
#import <ViewModel/UICollectionView+ViewModel.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPPreviewCollectionController ()
@property (weak, nonatomic) VMImagePickerStyle *style;
@property (weak, nonatomic) VMImagePickerConfig *config;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;
@property (weak, nonatomic) UIBarButtonItem *controlBarButtonItem;
@end

@implementation VMIPPreviewCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.toolbarItems = @[
        self.controlBarButtonItem,
    ];
    [self styleUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [RACObserve(self.config, original) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        VMIPPreviewToolBarView *toolBarView = self.controlBarButtonItem.customView;
        toolBarView.originalButton.selected = [x boolValue];
    }];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    if (parent) {
        ColumnRowFlowLayout *collectionViewFlowLayout = ColumnRowFlowLayout.new;
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionViewFlowLayout.columnCount = 1;
        collectionViewFlowLayout.rowCount = 1;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.collectionViewLayout = collectionViewFlowLayout;
        collectionViewFlowLayout.viewModel = self.viewModel.collectionViewModel;
        self.viewModel.collectionViewModel.collectionView = self.collectionView;
        [self.collectionView performBatchUpdates:^{
        } completion:^(BOOL) {
            if (self.previewIndexPath) {
                [self.collectionView scrollToItemAtIndexPath:self.previewIndexPath atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
            }
        } animationsEnabled:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.subviews.firstObject.alpha = 0.3f;
    self.navigationController.toolbar.translucent = YES;
    NSAssert([self.navigationController isKindOfClass:VMImagePickerController.class], @"Check!");
    self.viewModel.delegate = self.navigationController;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

- (void)styleUI {
    self.view.backgroundColor = [self.style colorWithThemeColors:self.style.bkgColors];
    self.navigationBarStyle = [[VMIPNavigationBarStyle alloc] initWithController:self];
    [self.navigationBarStyle formatBackButtonWithStyle:self.style];
}

#pragma mark - Getter

- (VMImagePickerStyle *)style {
    if (!_style) {
        VMImagePickerController *imagePickerController = self.navigationController ?: self.parentViewController;
        if ([imagePickerController isKindOfClass:VMImagePickerController.class]) {
            _style = imagePickerController.style;
        }
    }
    return _style;
}

- (VMImagePickerConfig *)config {
    if (!_config) {
        VMImagePickerController *imagePickerController = self.navigationController ?: self.parentViewController;
        if ([imagePickerController isKindOfClass:VMImagePickerController.class]) {
            _config = imagePickerController.config;
        }
    }
    return _config;
}

- (UIBarButtonItem *)controlBarButtonItem {
    if (_controlBarButtonItem) {
        return _controlBarButtonItem;
    }
    VMIPPreviewToolBarView *toolBarView = VMIPPreviewToolBarView.new;
    toolBarView.style = self.style;
    UIBarButtonItem *controlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBarView];
    _controlBarButtonItem = controlBarButtonItem;
    
    [toolBarView.editButton addTarget:self action:@selector(onEditClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [toolBarView.originalButton addTarget:self action:@selector(onOriginalClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [toolBarView.doneButton addTarget:self action:@selector(onDoneClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return controlBarButtonItem;
}

#pragma mark - Actions

- (void)onEditClicked:(id)sender {
    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    VMIPPreviewCellViewModel *cellViewModel = self.viewModel.collectionViewModel.sectionViewModels[indexPath.section][indexPath.item];
    VMIPVideoEditController *controller = VMIPVideoEditController.new;
    VMIPVideoEditViewModel *viewModel = [[VMIPVideoEditViewModel alloc] initWithAsset:cellViewModel.assetCellViewModel.asset];
    controller.viewModel = viewModel;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onOriginalClicked:(id)sender {
    self.config.original = !self.config.original;
}

- (void)onDoneClicked:(id)sender {
    if ([self.viewModel.delegate respondsToSelector:@selector(viewModel:didSelectedAssets:)]) {
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.viewModel.selectedCellViewModels.count];
        for (VMIPAssetCellViewModel *assetCellViewModel in self.viewModel.selectedCellViewModels) {
            [assets addObject:assetCellViewModel.asset];
        }
        [self.viewModel.delegate viewModel:self.viewModel didSelectedAssets:assets];
    }
}

@end
