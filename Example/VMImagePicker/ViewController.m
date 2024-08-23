//
//  ViewController.m
//  VMImagePicker
//
//  Created by ItghostFans on 07/10/2024.
//  Copyright (c) 2024 ItghostFans. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <VMImagePicker/PHPhotoLibrary+ImagePicker.h>
#import <VMImagePicker/PHAssetCollection+ImagePicker.h>
#import <VMImagePicker/VMIPAlbumTableController.h>
#import <VMImagePicker/VMIPAlbumTableControllerViewModel.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    PHAuthorizationStatus status = [PHPhotoLibrary albumAuthorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAlbumAuthorization:^(PHAuthorizationStatus status) {
                @strongify(self);
                [self loadAlbumIfNeed];
            }];
            break;
        }
        default: {
            [self loadAlbumIfNeed];
            break;
        }
    }
}

#pragma mark - Private

- (void)loadAlbumIfNeed {
    PHAuthorizationStatus status = [PHPhotoLibrary albumAuthorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusLimited: {
            NSArray *types = @[@(PHAssetCollectionTypeSmartAlbum), 
                               @(PHAssetCollectionTypeSmartAlbum),
                               @(PHAssetCollectionTypeAlbum),];
            NSArray *subtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary), 
                                  @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                  @(PHAssetCollectionSubtypeAlbumRegular),];
            VMIPAlbumTableControllerViewModel *viewModel = [[VMIPAlbumTableControllerViewModel alloc] initWithTypes:types subtypes:subtypes options:PHFetchOptions.new];
            VMIPAlbumTableController *controller = VMIPAlbumTableController.new;
            controller.viewModel = viewModel;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default: {
            break;
        }
    }
}

@end
