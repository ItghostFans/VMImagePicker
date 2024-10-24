//
//  VMIPVideoEditController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoEditController.h"
#import "VMIPVideoEditViewModel.h"
#import "VMIPVideoPlayer.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"
#import "VMIPNavigationBarStyle.h"
#import "VMIPVideoFrameCollectionController.h"
#import "VMImagePickerController.h"
#import "VMIPEditVideoCropView.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoEditController ()
@property (weak, nonatomic) VMImagePickerStyle *style;
@property (weak, nonatomic) VMImagePickerConfig *config;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;

@property (weak, nonatomic) VMIPVideoPlayer *videoPlayer;
@property (weak, nonatomic) VMIPVideoFrameCollectionController *frameController;
@property (weak, nonatomic) VMIPEditVideoCropView *cropView;

@end

@implementation VMIPVideoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleUI];
    [self frameController];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    [self.frameController didMoveToParentViewController:parent ? self : nil];
    [self cropView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.subviews.firstObject.alpha = 1.0f;
    self.navigationController.toolbar.translucent = NO;
    NSAssert([self.navigationController isKindOfClass:VMImagePickerController.class], @"Check!");
}

- (void)setViewModel:(VMIPVideoEditViewModel *)viewModel {
    @weakify(self);
    _viewModel = viewModel;
    [_viewModel loading:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
    } completion:^(NSError * _Nonnull error, AVPlayerItem * _Nonnull playerItem) {
        @strongify(self);
        [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
        // TODO: 测试播放。
        [self.videoPlayer play];
    }];
    self.frameController.viewModel = _viewModel.frameViewModel;
}

#pragma mark - Private

- (void)styleUI {
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

- (VMImagePickerConfig *)config {
    if (!_config) {
        VMImagePickerController *imagePickerController = self.navigationController ?: self.parentViewController;
        if ([imagePickerController isKindOfClass:VMImagePickerController.class]) {
            _config = imagePickerController.config;
        }
    }
    return _config;
}

- (VMIPVideoPlayer *)videoPlayer {
    if (_videoPlayer) {
        return _videoPlayer;
    }
    VMIPVideoPlayer *videoPlayer = VMIPVideoPlayer.new;
    _videoPlayer = videoPlayer;
    [self.view addSubview:_videoPlayer];
    [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
//        make.height.equalTo(self.view).multipliedBy(0.6f);
        make.bottom.equalTo(self.frameController.view.mas_top);
    }];
    return videoPlayer;
}

- (VMIPVideoFrameCollectionController *)frameController {
    if (_frameController) {
        return _frameController;
    }
    VMIPVideoFrameCollectionController *frameController = VMIPVideoFrameCollectionController.new;
    _frameController = frameController;
    [self addChildViewController:_frameController];
    [self.view addSubview:_frameController.view];
    [_frameController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        make.top.equalTo(self.videoPlayer.mas_bottom);
        make.height.mas_equalTo(72.0f);
    }];
    return frameController;
}

- (VMIPEditVideoCropView *)cropView {
    if (_cropView) {
        return _cropView;
    }
    VMIPEditVideoCropView *cropView = VMIPEditVideoCropView.new;
    _cropView = cropView;
    _cropView.style = self.style;
    [self.view addSubview:_cropView];
    CGFloat superWidth = CGRectGetWidth(self.view.bounds);
//    NSInteger factor = (NSInteger)(superWidth - self.config.videoCropDuration - (_cropView.barWidth * 2)) / self.config.videoCropDuration;
//    CGFloat width = factor * self.config.videoCropDuration;
//    CGFloat inset = (superWidth - width) / 2 + _cropView.barWidth;
    CGFloat margins = 10.0f;
    CGFloat inset = margins + _cropView.barWidth;
    self.frameController.collectionView.contentInset = UIEdgeInsetsMake(0.0f, inset, 0.0f, inset);
    [_cropView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width);
//        make.centerX.equalTo(self.view);
        make.leading.equalTo(self.view).offset(margins);
        make.trailing.equalTo(self.view).offset(-margins);
        make.top.bottom.equalTo(self.frameController.view);
    }];
    return cropView;
}

@end
