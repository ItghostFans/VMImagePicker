//
//  VMIPAlbumTableController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableController.h"
#import "VMIPAlbumTableControllerViewModel.h"
#import <ViewModel/TableViewModel+UITableViewDelegate.h>
#import "VMIPAssetCollectionController.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import "VMIPAlbumCellViewModel.h"

@interface VMIPAlbumTableController () <UITableViewDelegate>
// TODO: 添加需要的View，建议使用懒加载
@end

@implementation VMIPAlbumTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.viewModel.tableViewModel.tableView = self.tableView;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

// TODO: 添加需要的View，建议使用懒加载

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

#pragma mark - Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [self.viewModel.tableViewModel.class instanceMethodSignatureForSelector:aSelector];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.viewModel.tableViewModel];
}

@end
