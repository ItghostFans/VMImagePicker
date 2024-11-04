//
//  VMIPVideoHandler.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/2.
//

#import "VMIPVideoHandler.h"
#import "VMIPVideoPlayer.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoHandler ()
@property (weak, nonatomic) VMImagePickerStyle *style;
@property (weak, nonatomic) VMIPVideoPlayer *videoPlayer;
@property (weak, nonatomic) UIButton *playButton;
@end

@implementation VMIPVideoHandler

- (instancetype)initWithVideoPlayer:(VMIPVideoPlayer *)videoPlayer
                              style:(VMImagePickerStyle *)style {
    if (self = [self init]) {
        _videoPlayer = videoPlayer;
        _style = style;
        @weakify(self);
        [[RACObserve(self.videoPlayer, status) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            VMIPVideoPlayerStatus status = [x integerValue];
            self.playButton.hidden = status == VMIPVideoPlayerStatusPlaying;
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayerTap:)];
        [_videoPlayer addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Actions

- (void)onPlayerTap:(UITapGestureRecognizer *)tap {
    switch (self.videoPlayer.status) {
        case VMIPVideoPlayerStatusEnd: {
            [self.videoPlayer seekToTime:0.0f completion:^(BOOL finished) {
            }];
        }
        case VMIPVideoPlayerStatusReady:
        case VMIPVideoPlayerStatusNone:
        case VMIPVideoPlayerStatusError:
        case VMIPVideoPlayerStatusPause: {
            [self.videoPlayer play];
            break;
        }
        case VMIPVideoPlayerStatusPlaying: {
            [self.videoPlayer pause];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Getter

- (UIButton *)playButton {
    if (_playButton) {
        return _playButton;
    }
    UIButton *playButton = UIButton.new;
    _playButton = playButton;
    _playButton.userInteractionEnabled = NO;
    [self.style styleButton:_playButton images:self.style.videoEditPlayImages];
    [self.videoPlayer addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80.0f, 80.0f));
        make.center.equalTo(self.videoPlayer);
    }];
    return playButton;
}

@end
