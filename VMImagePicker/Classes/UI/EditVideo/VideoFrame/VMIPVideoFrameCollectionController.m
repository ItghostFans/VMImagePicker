//
//  VMIPVideoFrameCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoFrameCollectionController.h"
#import "VMIPVideoFrameCollectionControllerViewModel.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionViewModel.h>
#import <VMLocalization/VMLocalization.h>

@interface VMIPVideoFrameCollectionFlowLayout : UICollectionViewFlowLayout
@end

@implementation VMIPVideoFrameCollectionFlowLayout

- (UIUserInterfaceLayoutDirection)developmentLayoutDirection {
    return self.flipsHorizontallyInOppositeLayoutDirection ? UIUserInterfaceLayoutDirectionRightToLeft : UIUserInterfaceLayoutDirectionLeftToRight;
}

- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}

@end

@interface VMIPVideoFrameCollectionController ()
// TODO: 添加需要的View，建议使用懒加载
@end

@implementation VMIPVideoFrameCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
//    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
//        self.collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    }
    VMIPVideoFrameCollectionFlowLayout *collectionViewFlowLayout = VMIPVideoFrameCollectionFlowLayout.new;
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.directionalEdges.equalTo(self.view);
    }];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    if (parent) {
        [parent.view layoutIfNeeded];
        self.viewModel.collectionViewModel.collectionView = self.collectionView;
        [self.viewModel loadVideoCompletion:^(NSError * _Nonnull error) {
        }];
    }
}

- (void)setViewModel:(VMIPVideoFrameCollectionControllerViewModel *)viewModel {
    [super setViewModel:viewModel];
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

// TODO: 添加需要的View，建议使用懒加载

@end
