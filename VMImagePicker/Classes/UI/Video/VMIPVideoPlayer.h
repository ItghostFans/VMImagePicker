//
//  VMIPVideoPlayer.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/21.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVPlayerItem.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VMIPVideoPlayerStatus) {
    VMIPVideoPlayerStatusNone,          // 未初始化
    VMIPVideoPlayerStatusReady,         // 准备播放
    VMIPVideoPlayerStatusPlaying,       // 播放中
    VMIPVideoPlayerStatusPause,         // 暂停
    VMIPVideoPlayerStatusEnd,           // 播放结束
    VMIPVideoPlayerStatusError,         // 播放失败
};

@interface VMIPVideoPlayer : UIView

@property (assign, nonatomic, readonly) NSTimeInterval duration;        // 视频时长
@property (assign, nonatomic, readonly) NSTimeInterval time;            // 当前播放时间
@property (assign, nonatomic, readonly) VMIPVideoPlayerStatus status;   // 播放器状态

- (void)seekToTime:(NSTimeInterval)time completion:(void (^ _Nullable)(BOOL finished))completion;

#pragma mark - AVPlayer
@property (strong, readonly, nullable) NSError *error;
@property (strong, readonly, nullable) AVPlayerItem *currentItem;

- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)playerItem;
- (void)play;
- (void)pause;

#pragma mark - AVPlayerLayer

@property (strong, nonatomic) AVLayerVideoGravity videoGravity;

@end

NS_ASSUME_NONNULL_END
