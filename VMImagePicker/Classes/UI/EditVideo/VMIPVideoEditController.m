//
//  VMIPVideoEditController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoEditController.h"
#import "VMIPVideoEditViewModel.h"
#import "VMIPVideoPlayer.h"
#import "VMIPVideoFrameCollectionController.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoEditController ()

@property (weak, nonatomic) VMIPVideoPlayer *videoPlayer;
@property (weak, nonatomic) VMIPVideoFrameCollectionController *frameController;

@end

@implementation VMIPVideoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (VMIPVideoPlayer *)videoPlayer {
    if (_videoPlayer) {
        return _videoPlayer;
    }
    VMIPVideoPlayer *videoPlayer = VMIPVideoPlayer.new;
    _videoPlayer = videoPlayer;
    [self.view addSubview:_videoPlayer];
    [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.6f);
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
        make.top.equalTo(self.videoPlayer.mas_bottom);
    }];
    return frameController;
}

@end
