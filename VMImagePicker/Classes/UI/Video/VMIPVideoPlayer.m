//
//  VMIPVideoPlayer.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/21.
//

#import "VMIPVideoPlayer.h"

#import <ViewModel/WeakifyProxy.h>
#import <AVFoundation/AVAsset.h>

@interface VMIPVideoPlayer ()
@property (assign, nonatomic) NSTimeInterval time;
@property (assign, nonatomic) VMIPVideoPlayerStatus status;

@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (weak, nonatomic) AVPlayerLayer *videoLayer;
@property (strong, nonatomic) WeakifyProxy *timerProxy;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation VMIPVideoPlayer
#pragma clang diagnostic pop

@dynamic error;
@dynamic currentItem;
@dynamic videoGravity;

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoLayer.frame = self.bounds;
}

- (void)dealloc {
    [_displayLink invalidate];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.videoLayer.videoRect, point)) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

- (void)seekToTime:(NSTimeInterval)time completion:(void (^ _Nullable)(BOOL finished))completion {
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(time, 1000)
                 toleranceBefore:kCMTimePositiveInfinity
                  toleranceAfter:kCMTimePositiveInfinity
               completionHandler:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark - AVPlayer

- (void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)playerItem {
    [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    switch (self.videoPlayer.status) {
        case AVPlayerStatusReadyToPlay: {
            self.status = VMIPVideoPlayerStatusReady;
            break;
        }
        case AVPlayerStatusFailed: {
            self.status = VMIPVideoPlayerStatusError;
            break;
        }
        default: {
            break;
        }
    }
}

- (void)play {
    [self.videoPlayer play];
    if (_displayLink) {
        _displayLink.paused = NO;
        return;
    }
    if (@available(iOS 15.0, *)) {
        self.displayLink.preferredFrameRateRange = CAFrameRateRangeMake(24.0f, 60.0f, 30.0f);
    } else {
        self.displayLink.preferredFramesPerSecond = 2;
    }
    [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}

#pragma mark - AVPlayer Private

- (void)updateByTimeControlStatus {
    switch (self.videoPlayer.timeControlStatus) {
        case AVPlayerTimeControlStatusPaused: {
            if (self.status != VMIPVideoPlayerStatusPause) {
                self.status = VMIPVideoPlayerStatusPause;
            }
            break;
        }
        case AVPlayerTimeControlStatusPlaying: {
            if (self.status != VMIPVideoPlayerStatusPlaying) {
                self.status = VMIPVideoPlayerStatusPlaying;
            }
            break;
        }
    }
}

- (void)pause {
    [self.videoPlayer pause];
    self.status = VMIPVideoPlayerStatusPause;
    _displayLink.paused = YES;
}

#pragma mark - Public Getter

- (NSTimeInterval)time {
    return (NSTimeInterval)self.videoPlayer.currentTime.value / self.videoPlayer.currentTime.timescale;
}

- (NSTimeInterval)duration {
    if (self.currentItem.duration.timescale == 0) {
        return 0.0f;
    }
    return (NSTimeInterval)self.currentItem.duration.value / self.currentItem.duration.timescale;
}

#pragma mark - Private Getter

- (AVPlayer *)videoPlayer {
    if (_videoPlayer) {
        return _videoPlayer;
    }
    AVPlayer *videoPlayer = AVPlayer.new;
    _videoPlayer = videoPlayer;
    return videoPlayer;
}

- (AVPlayerLayer *)videoLayer {
    if (_videoLayer) {
        return _videoLayer;
    }
    AVPlayerLayer *videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    _videoLayer = videoLayer;
    [self.layer addSublayer:_videoLayer];
    return videoLayer;
}

- (WeakifyProxy *)timerProxy {
    if (_timerProxy) {
        return _timerProxy;
    }
    _timerProxy = [[WeakifyProxy alloc] initWithTarget:self];
    return _timerProxy;
}

- (CADisplayLink *)displayLink {
    if (_displayLink) {
        return _displayLink;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self.timerProxy selector:@selector(onPlayDisplayLink:)];
    return _displayLink;
}

#pragma mark - Player

- (void)onPlayDisplayLink:(CADisplayLink *)displayLink {
//    if (self.videoPlayer.status != AVPlayerStatusReadyToPlay) {
//        return;
//    }
//    if (self.duration == 0.0f) {
//        return;
//    }
    if (self.videoPlayer.error) {
        self.status = VMIPVideoPlayerStatusError;
        [_displayLink invalidate];
        _displayLink = nil;
        return;
    }
    self.time = (NSTimeInterval)self.videoPlayer.currentTime.value / self.videoPlayer.currentTime.timescale;
    if (self.duration <= self.time) {
        self.status = VMIPVideoPlayerStatusEnd;
        [_displayLink invalidate];
        _displayLink = nil;
    } else {
        [self updateByTimeControlStatus];
    }
}

#pragma mark - Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.videoPlayer respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.videoLayer respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature;
    if ([self.videoPlayer respondsToSelector:aSelector]) {
        methodSignature = [self.videoPlayer.class instanceMethodSignatureForSelector:aSelector];
    } else
    if ([self.videoLayer respondsToSelector:aSelector]) {
        methodSignature = [self.videoLayer.class instanceMethodSignatureForSelector:aSelector];
    }
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.videoPlayer respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.videoPlayer];
    } else
    if ([self.videoLayer respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.videoLayer];
    }
}

@end
