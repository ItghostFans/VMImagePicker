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

@interface VMIPVideoFrameCollectionController ()
// TODO: 添加需要的View，建议使用懒加载
@end

@implementation VMIPVideoFrameCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
