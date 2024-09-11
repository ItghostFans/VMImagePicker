//
//  VMIPAssetCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionController.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/ColumnRowFlowLayout.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "VMImagePickerStyle.h"
#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerController.h"
#import "VMIPToolBarControlView.h"

@interface VMIPAssetCollectionController ()
@property (strong, nonatomic) VMImagePickerStyle *style;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;
@property (weak, nonatomic) UIBarButtonItem *controlBarButtonItem;
@end

@implementation VMIPAssetCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbarItems = @[
        self.controlBarButtonItem,
    ];
    [self styleUI];
    @weakify(self);
    [[RACObserve(self.viewModel, name) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.navigationItem.title = x;
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    ColumnRowFlowLayout *collectionViewFlowLayout = ColumnRowFlowLayout.new;
    collectionViewFlowLayout.columnCount = self.style.assetColumn;
    collectionViewFlowLayout.rowCount = self.style.assetRow;
    if (collectionViewFlowLayout.columnCount) {
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    } else
    if (collectionViewFlowLayout.rowCount) {
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    collectionViewFlowLayout.contentInset = UIEdgeInsetsMake(10.0f, 5.0f, 10.0f, 5.0f);
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    collectionViewFlowLayout.viewModel = self.viewModel.collectionViewModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Public

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
        } else {
            _style = VMImagePickerStyle.new;
        }
    }
    return _style;
}

- (UIBarButtonItem *)controlBarButtonItem {
    if (_controlBarButtonItem) {
        return _controlBarButtonItem;
    }
    VMIPToolBarControlView *controlView = VMIPToolBarControlView.new;
    controlView.style = self.style;
    UIBarButtonItem *controlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:controlView];
    _controlBarButtonItem = controlBarButtonItem;
    
    [controlView.previewButton addTarget:self action:@selector(onPreviewClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [controlView.originalButton addTarget:self action:@selector(onOriginalClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [controlView.doneButton addTarget:self action:@selector(onDoneClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return controlBarButtonItem;
}

#pragma mark - Actions

- (void)onPreviewClicked:(id)sender {
    
}

- (void)onOriginalClicked:(id)sender {
    
}

- (void)onDoneClicked:(id)sender {
    
}

@end
