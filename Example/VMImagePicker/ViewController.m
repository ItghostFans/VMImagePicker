//
//  ViewController.m
//  VMImagePicker
//
//  Created by ItghostFans on 07/10/2024.
//  Copyright (c) 2024 ItghostFans. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <VMImagePicker/PHPhotoLibrary+ImagePicker.h>
#import <VMImagePicker/PHAssetCollection+ImagePicker.h>
#import <VMImagePicker/VMIPAlbumTableController.h>
#import <VMImagePicker/VMImagePickerController.h>
#import <VMImagePicker/VMIPAlbumTableControllerViewModel.h>

@interface ViewController ()
@property (weak, nonatomic) UIButton *openImagePickerButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.openImagePickerButton addTarget:self action:@selector(onOpenImagePickerClicked:) forControlEvents:(UIControlEventTouchUpInside)];
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
            VMImagePickerController *imagePickerController = [[VMImagePickerController alloc] initWithRootViewController:controller];
//            [self.navigationController pushViewController:controller animated:YES];
            [self presentViewController:imagePickerController animated:YES completion:^{
            }];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Getter

- (UIButton *)openImagePickerButton {
    if (!_openImagePickerButton) {
        UIButton *openImagePickerButton = UIButton.new;
        _openImagePickerButton = openImagePickerButton;
        [_openImagePickerButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        [_openImagePickerButton setTitle:NSLocalizedString(@"Open", nil) forState:(UIControlStateNormal)];
        [self.view addSubview:_openImagePickerButton];
        [_openImagePickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    return _openImagePickerButton;
}

#pragma mark - Actions

- (void)onOpenImagePickerClicked:(id)sender {
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

@end
