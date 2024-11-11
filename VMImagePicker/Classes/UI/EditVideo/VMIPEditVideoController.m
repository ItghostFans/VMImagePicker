//
//  VMIPEditVideoController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPEditVideoController.h"
#import "VMIPVideoEditViewModel.h"
#import "VMIPVideoPlayer.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"
#import "VMIPNavigationBarStyle.h"
#import "VMIPVideoFrameCollectionController.h"
#import "VMIPVideoFrameCollectionControllerViewModel.h"
#import "VMImagePickerController.h"
#import "VMIPEditVideoCropView.h"
#import "VMIPEditVideoTimeIndicatorView.h"
#import "VMIPVideoHandler.h"
#import "VMIPEditVideoToolBarView.h"
#import "VMIPVideoViewModel.h"

#import <VMLocalization/VMLocalization.h>

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPEditVideoController ()
@property (weak, nonatomic) VMImagePickerStyle *style;
@property (weak, nonatomic) VMImagePickerConfig *config;
@property (strong, nonatomic) VMIPNavigationBarStyle *navigationBarStyle;

@property (weak, nonatomic) VMIPVideoPlayer *videoPlayer;
@property (assign, nonatomic) VMIPVideoPlayerStatus playerStatus;
@property (strong, nonatomic) VMIPVideoHandler *videoPlayHandler;

@property (weak, nonatomic) VMIPVideoFrameCollectionController *frameController;
@property (weak, nonatomic) VMIPEditVideoCropView *cropView;
@property (weak, nonatomic) VMIPEditVideoTimeIndicatorView *timeIndicatorView;
@property (assign, nonatomic) CGFloat timeIndicatorWidth;

@property (weak, nonatomic) UIBarButtonItem *controlBarButtonItem;

@end

@implementation VMIPEditVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbarItems = @[
        self.controlBarButtonItem,
    ];
    _timeIndicatorWidth = 2.0f;
    [self styleUI];
    self.frameController.viewModel = _viewModel.frameViewModel;
    _videoPlayHandler = [[VMIPVideoHandler alloc] initWithVideoPlayer:self.videoPlayer style:self.style];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    self.viewModel.frameViewModel.videoCropFrameCount = self.config.videoCropFrameCount;
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
        [RACObserve(self.videoPlayer, time) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (self.videoPlayer.duration == 0.0f) {
                return;
            }
            NSTimeInterval time = [x doubleValue];
            CGFloat progress = time / self.videoPlayer.duration;
            CGFloat offset = self.cropView.barWidth + (self.timeIndicatorOffsetWidth * progress);
            [self.timeIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cropView).offset(offset);
            }];
            [self.view layoutIfNeeded];
        }];
    }];
    
}

- (void)onDoneClicked:(id)sender {
    NSString *videoPreset = self.config.original ? AVAssetExportPresetHighestQuality : AVAssetExportPresetMediumQuality;
    CGFloat begin = self.cropView.begin;
    CGFloat end = self.cropView.end;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(begin * self.videoPlayer.duration * 1000, 1000), CMTimeMake((end - begin) * self.videoPlayer.duration * 1000, 1000));
    [self.viewModel.videoViewModel exportVideoPreset:videoPreset timeRange:timeRange directory:self.config.directory loading:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
    } completion:^(NSError * _Nullable error, NSString * _Nullable videoPath) {
        NSLog(@"");
    }];
}

- (void)onTimeIndicatorPan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.playerStatus = self.videoPlayer.status;
            if (self.playerStatus == VMIPVideoPlayerStatusPlaying) {
                [self.videoPlayer pause];
            }
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [pan translationInView:self.view];
            CGRect timeIndicatorFrameInCropView = [self.view convertRect:self.timeIndicatorView.frame toView:self.cropView];
            CGFloat x = CGRectGetMinX(timeIndicatorFrameInCropView);
            x += translation.x;
            [pan setTranslation:CGPointZero inView:self.view];
            
            CGFloat offsetMin = self.cropView.barWidth;
            CGFloat offsetMax = self.cropView.barWidth + self.timeIndicatorOffsetWidth;
            CGFloat offset = MIN(MAX(x, offsetMin), offsetMax);
            [self.timeIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cropView).offset(offset);
            }];
            [self.view layoutIfNeeded];
            CGFloat progress = (offset - self.cropView.barWidth) / self.timeIndicatorOffsetWidth;
            [self.videoPlayer seekToTime:progress * self.videoPlayer.duration completion:^(BOOL finished) {
            }];
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            if (self.playerStatus == VMIPVideoPlayerStatusPlaying) {
                [self.videoPlayer play];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.playerStatus == VMIPVideoPlayerStatusPlaying) {
                [self.videoPlayer play];
            }
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Private

- (void)styleUI {
    self.view.backgroundColor = [self.style colorWithThemeColors:self.style.bkgColors];
    self.navigationBarStyle = [[VMIPNavigationBarStyle alloc] initWithController:self];
    [self.navigationBarStyle formatBackButtonWithStyle:self.style];
}

- (CGFloat)timeIndicatorOffsetWidth {
    return CGRectGetWidth(self.cropView.frame) - (self.cropView.barWidth * 2) - self.timeIndicatorWidth;
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
    self.frameController.collectionView.contentInset = UIDirectionalEdgesInsetsMake(0.0f, inset, 0.0f, inset);
    [_cropView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width);
//        make.centerX.equalTo(self.view);
        make.leading.equalTo(self.view).offset(margins);
        make.trailing.equalTo(self.view).offset(-margins);
        make.top.bottom.equalTo(self.frameController.view);
    }];
    return cropView;
}

- (VMIPEditVideoTimeIndicatorView *)timeIndicatorView {
    if (_timeIndicatorView) {
        return _timeIndicatorView;
    }
    VMIPEditVideoTimeIndicatorView *timeIndicatorView = VMIPEditVideoTimeIndicatorView.new;
    _timeIndicatorView = timeIndicatorView;
    _timeIndicatorView.backgroundColor = UIColor.redColor;
    _timeIndicatorView.hitTestInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    [self.view insertSubview:_timeIndicatorView belowSubview:self.cropView];
    [_timeIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.cropView);
        make.width.mas_equalTo(self.timeIndicatorWidth);
        make.left.equalTo(self.cropView).offset(self.cropView.barWidth);
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTimeIndicatorPan:)];
    [_timeIndicatorView addGestureRecognizer:pan];
    return timeIndicatorView;
}

- (UIBarButtonItem *)controlBarButtonItem {
    if (_controlBarButtonItem) {
        return _controlBarButtonItem;
    }
    VMIPEditVideoToolBarView *toolBarView = VMIPEditVideoToolBarView.new;
    toolBarView.style = self.style;
    UIBarButtonItem *controlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBarView];
    _controlBarButtonItem = controlBarButtonItem;
    
    [toolBarView.doneButton addTarget:self action:@selector(onDoneClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return controlBarButtonItem;
}

@end
