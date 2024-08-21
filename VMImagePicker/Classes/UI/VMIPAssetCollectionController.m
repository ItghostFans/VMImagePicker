//
//  VMIPAssetCollectionController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionController.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import <ViewModel/CollectionViewModel.h>

@interface VMIPAssetCollectionController ()
// TODO: 添加需要的View，建议使用懒加载
@end

@implementation VMIPAssetCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
    self.viewModel.collectionViewModel.collectionView = self.collectionView;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

// TODO: 添加需要的View，建议使用懒加载

@end
