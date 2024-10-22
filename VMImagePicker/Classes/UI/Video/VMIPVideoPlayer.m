//
//  VMIPVideoPlayer.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/21.
//

#import "VMIPVideoPlayer.h"

@interface VMIPVideoPlayer ()

@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (weak, nonatomic) AVPlayerLayer *videoLayer;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation VMIPVideoPlayer
#pragma clang diagnostic pop

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoLayer.frame = self.bounds;
}

- (void)seekToTime:(NSTimeInterval)time completion:(void (^ _Nullable)(BOOL finished))completion {
    [self.videoPlayer seekToTime:CMTimeMake(time * 1000, 1000) completionHandler:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark - Public Getter

- (NSTimeInterval)time {
    return (NSTimeInterval)self.videoPlayer.currentTime.value / self.videoPlayer.currentTime.timescale;
}

- (NSTimeInterval)duration {
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
