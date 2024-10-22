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

@interface VMIPVideoPlayer : UIView

@property (assign, nonatomic, readonly) NSTimeInterval duration;    // 视频时长
@property (assign, nonatomic, readonly) NSTimeInterval time;        // 当前播放时间

- (void)seekToTime:(NSTimeInterval)time completion:(void (^ _Nullable)(BOOL finished))completion;

#pragma mark - AVPlayer
@property (assign, nonatomic, readonly) AVPlayerStatus status;
@property (strong, readonly, nullable) AVPlayerItem *currentItem;

- (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)playerItem;
- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
