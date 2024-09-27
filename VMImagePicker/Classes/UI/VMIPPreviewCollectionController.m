//
//  VMIPPreviewCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import "VMIPPreviewCollectionController.h"
#import "VMIPPreviewCollectionControllerViewModel.h"
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/ColumnRowFlowLayout.h>
#import <Masonry/Masonry.h>
#import "VMImagePickerStyle.h"
#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerController.h"

@interface VMIPPreviewCollectionController ()
@property (strong, nonatomic) VMImagePickerStyle *style;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;
@end

@implementation VMIPPreviewCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
        if (self.previewIndexPath) {
            [self.collectionView scrollToItemAtIndexPath:self.previewIndexPath atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.subviews.firstObject.alpha = 0.3f;
    self.navigationController.toolbar.translucent = YES;
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
        } else {
            _style = VMImagePickerStyle.new;
        }
    }
    return _style;
}

// TODO: 添加需要的View，建议使用懒加载

@end
