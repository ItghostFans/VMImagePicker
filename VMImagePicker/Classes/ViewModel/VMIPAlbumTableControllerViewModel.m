//
//  VMIPAlbumTableControllerViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableControllerViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/TableViewModel.h>
#import <ViewModel/UITableView+ViewModel.h>

#import "PHAssetCollection+ImagePicker.h"
#import "VMIPAlbumCellViewModel.h"

@interface VMIPAlbumTableControllerViewModel ()
@property (strong, nonatomic, readonly) NSArray<__kindof NSNumber *> *types;
@property (strong, nonatomic, readonly) NSArray<__kindof NSNumber *> *subtypes;
@property (strong, nonatomic) PHFetchOptions *options;
@property (weak, nonatomic, readonly) SectionViewModel *sectionViewModel;
@end

@implementation VMIPAlbumTableControllerViewModel

- (instancetype)initWithTypes:(NSArray<__kindof NSNumber *> *)types
                     subtypes:(NSArray<__kindof NSNumber *> *)subtypes
                      options:(PHFetchOptions * _Nullable)options {
    if (self = [self initWithTableViewModel:TableViewModel.new]) {
        [self.tableViewModel.sectionViewModels addViewModel:SectionViewModel.new];
        _sectionViewModel = self.tableViewModel.sectionViewModels.firstViewModel;
        _types = types;
        _subtypes = subtypes;
        _options = options;
        [self loadAlbums];
    }
    return self;
}

#pragma mark - Private

- (void)loadAlbums {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
        @strongify(self);
        NSArray<__kindof PHCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithTypes:self.types subtypes:self.subtypes options:self.options];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self tableViewUpdate:^{
                for (PHAssetCollection *assetCollection in assetCollections) {
                    VMIPAlbumCellViewModel *cellViewModel = [[VMIPAlbumCellViewModel alloc] initWithAssetCollection:assetCollection];
                    [self.sectionViewModel addViewModel:cellViewModel];
                }
            } completion:^(BOOL finished) {
            }];
        });
    });
}

#pragma mark - Update TableView

- (void)tableViewUpdate:(void(^)(void))update completion:(void (^)(BOOL finished))completion {
    if (self.tableViewModel.tableView) {
        [self.tableViewModel.tableView performBatchUpdates:update rowAnimation:(UITableViewRowAnimationNone) completion:completion];
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
