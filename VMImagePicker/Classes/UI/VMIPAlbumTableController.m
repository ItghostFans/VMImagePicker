//
//  VMIPAlbumTableController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumTableController.h"
#import "VMIPAlbumTableControllerViewModel.h"
#import <ViewModel/TableViewModel.h>

@interface VMIPAlbumTableController ()
// TODO: 添加需要的View，建议使用懒加载
@end

@implementation VMIPAlbumTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.viewModel.tableViewModel.tableView = self.tableView;
}

#pragma mark - Public

#pragma mark - Actions

#pragma mark - Private

#pragma mark - Getter

// TODO: 添加需要的View，建议使用懒加载

@end
