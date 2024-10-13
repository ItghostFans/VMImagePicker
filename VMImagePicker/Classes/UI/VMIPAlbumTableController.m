//
//  VMIPAlbumTableController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableController.h"
#import "VMIPAlbumTableControllerViewModel.h"
#import "VMIPAssetCollectionController.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import "VMIPAlbumCellViewModel.h"
#import "VMImagePickerStyle.h"
#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerController.h"

#import <ViewModel/TableViewModel+UITableViewDelegate.h>

@interface VMIPAlbumTableController () <UITableViewDelegate>
@property (weak, nonatomic) VMImagePickerStyle *style;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;
@end

@implementation VMIPAlbumTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleUI];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.viewModel.tableViewModel.tableView = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

- (void)styleUI {
    self.navigationItem.title = self.style.albumTitle;
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
        }
    }
    return _style;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.tableViewModel tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (self.navigationController) {
        VMIPAlbumCellViewModel *cellViewModel = self.viewModel.tableViewModel.sectionViewModels[indexPath.section][indexPath.row];
        VMIPAssetCollectionControllerViewModel *viewModel = [[VMIPAssetCollectionControllerViewModel alloc] initWithAssetCollection:cellViewModel.assetCollection options:self.viewModel.options];
        VMIPAssetCollectionController *controller = VMIPAssetCollectionController.new;
        controller.viewModel = viewModel;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
