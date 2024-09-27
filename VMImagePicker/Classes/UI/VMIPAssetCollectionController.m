//
//  VMIPAssetCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionController.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import "VMIPPreviewCollectionController.h"
#import "VMIPPreviewCollectionControllerViewModel.h"
#import "VMIPAssetCellViewModel.h"
#import "VMImagePickerStyle.h"
#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerController.h"
#import "VMIPAssetToolBarView.h"
#import "VMIPPreviewCellViewModel.h"

#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/ColumnRowFlowLayout.h>
#import <ViewModel/CollectionViewModel+UICollectionViewDelegate.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface VMIPAssetCollectionController () <UICollectionViewDelegate>
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
    self.collectionView.delegate = self;
    self.viewModel.collectionViewModel.collectionView = self.collectionView;
    
    [RACObserve(self.viewModel, selectedCellViewModels) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        VMIPAssetToolBarView *toolBarView = self.controlBarButtonItem.customView;
        NSString *title = [self.style titleWithControlThemeTitles:self.style.toolPreviewButtonTitles state:(UIControlStateNormal)];
        if ([title containsString:@"(%@)"]) {
            NSUInteger count = [x count];
            if (count) {
                title = [NSString stringWithFormat:title, @(count)];
                toolBarView.previewButton.enabled = YES;
            } else {
                title = [title stringByReplacingOccurrencesOfString:@"(%@)" withString:@""];
                toolBarView.previewButton.enabled = NO;
            }
        }
        [toolBarView.previewButton setTitle:title forState:(UIControlStateNormal)];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.subviews.firstObject.alpha = 1.0f;
    self.navigationController.toolbar.translucent = NO;
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
    VMIPAssetToolBarView *toolBarView = VMIPAssetToolBarView.new;
    toolBarView.style = self.style;
    UIBarButtonItem *controlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBarView];
    _controlBarButtonItem = controlBarButtonItem;
    
    [toolBarView.previewButton addTarget:self action:@selector(onPreviewClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [toolBarView.originalButton addTarget:self action:@selector(onOriginalClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [toolBarView.doneButton addTarget:self action:@selector(onDoneClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return controlBarButtonItem;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.collectionViewModel collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    if (self.navigationController) {
        CollectionViewModel *collectionViewModel = CollectionViewModel.new;
        SectionViewModel *sectionViewModel = SectionViewModel.new;
        for (VMIPAssetCellViewModel *assetCellViewModel in self.viewModel.sectionViewModel.viewModels) {
            VMIPPreviewCellViewModel *cellViewModel = [[VMIPPreviewCellViewModel alloc] initWithAssetCellViewModel:assetCellViewModel];
            [sectionViewModel addViewModel:cellViewModel];
        }
        [collectionViewModel.sectionViewModels addViewModel:sectionViewModel];
        VMIPPreviewCollectionControllerViewModel *viewModel = [[VMIPPreviewCollectionControllerViewModel alloc] initWithCollectionViewModel:collectionViewModel];
        VMIPPreviewCollectionController *controller = VMIPPreviewCollectionController.new;
        controller.viewModel = viewModel;
        controller.previewIndexPath = indexPath;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.viewModel.collectionViewModel respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [self.viewModel.collectionViewModel.class instanceMethodSignatureForSelector:aSelector];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.viewModel.collectionViewModel];
}

#pragma mark - Actions

- (void)onPreviewClicked:(id)sender {
    
}

- (void)onOriginalClicked:(id)sender {
    
}

- (void)onDoneClicked:(id)sender {
    
}

@end
