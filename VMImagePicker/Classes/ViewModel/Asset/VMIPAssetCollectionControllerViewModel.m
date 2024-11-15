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

@interface VMIPAssetCollectionControllerViewModel () <IVMIPAssetCellViewModelSelectedDelegate, PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchOptions *options;
@property (weak, nonatomic) SectionViewModel *sectionViewModel;
@property (strong, nonatomic) NSMutableArray *selectedCellViewModels;
@property (strong, nonatomic) PHFetchResult<__kindof PHAsset *> *fetchResult;
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
        [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
    }
    return self;
}

- (void)dealloc {
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    if (NSThread.isMainThread) {
        [self handleAssetChangeInstance:changeInstance];
    } else {
        [self performSelectorOnMainThread:@selector(handleAssetChangeInstance:) withObject:changeInstance waitUntilDone:NO];
    }
}

#pragma mark - Private

- (void)handleAssetChangeInstance:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.fetchResult];
    if (!changeDetails) {
        return;
    }
    self.fetchResult = changeDetails.fetchResultAfterChanges;
    [self reload];
}

- (void)loadAssets {
    self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:self.options];
    [self reload];
}

- (void)reload {
    @weakify(self);
    [self collectionViewUpdate:^{
        [self.sectionViewModel removeAllViewModels];
        for (PHAsset *asset in self.fetchResult) {
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
    } completion:^(BOOL finished) {
    }];
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
