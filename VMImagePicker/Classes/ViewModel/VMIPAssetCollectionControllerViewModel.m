//
//  VMIPAssetCollectionControllerViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCollectionControllerViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionControllerViewModel.h>
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/UICollectionView+ViewModel.h>
#import <VMIPAssetCellViewModel.h>

@interface VMIPAssetCollectionControllerViewModel () <IVMIPAssetCellViewModelSelectedDelegate>
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchOptions *options;
@property (weak, nonatomic) SectionViewModel *sectionViewModel;
@property (strong, nonatomic) NSMutableArray *selectedCellViewModels;
@end

@implementation VMIPAssetCollectionControllerViewModel

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection
                                options:(PHFetchOptions * _Nullable)options {
    if (self = [self initWithCollectionViewModel:CollectionViewModel.new]) {
        [self.collectionViewModel.sectionViewModels addViewModel:SectionViewModel.new];
        _selectedCellViewModels = NSMutableArray.new;
        _sectionViewModel = self.collectionViewModel.sectionViewModels.firstViewModel;
        _assetCollection = assetCollection;
        _options = options;
        _name = assetCollection.localizedTitle;
        [self loadAssets];
    }
    return self;
}

#pragma mark - Private

- (void)loadAssets {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
        @strongify(self);
        NSArray<__kindof PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:self.options];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self collectionViewUpdate:^{
//                for (NSUInteger index = 0; index < 9; ++index) {
                    for (PHAsset *asset in assets) {
                        VMIPAssetCellViewModel *cellViewModel = [[VMIPAssetCellViewModel alloc] initWithAsset:asset];
                        cellViewModel.selectedDelegate = self;
                        [self.sectionViewModel addViewModel:cellViewModel];
                        @weakify(cellViewModel);
                        [RACObserve(cellViewModel, selected) subscribeNext:^(id  _Nullable x) {
                            @strongify(self);
                            @strongify(cellViewModel);
                            if (!cellViewModel) {
                                return;
                            }
                            if ([x boolValue]) {
                                [[self mutableArrayValueForKey:NSStringFromSelector(@selector(selectedCellViewModels))] addObject:cellViewModel];
                            } else {
                                [[self mutableArrayValueForKey:NSStringFromSelector(@selector(selectedCellViewModels))] removeObject:cellViewModel];
                            }
                        }];
                    }
//                }
            } completion:^(BOOL finished) {
            }];
        });
    });
}

#pragma mark - Update TableView

- (void)collectionViewUpdate:(void(^)(void))update completion:(void (^)(BOOL finished))completion {
    if (self.collectionViewModel.collectionView) {
        [self.collectionViewModel.collectionView performBatchUpdates:update completion:completion animationsEnabled:NO];
    } else {
        if (update) {
            update();
        }
        if (completion) {
            completion(YES);
        }
    }
}

@end
