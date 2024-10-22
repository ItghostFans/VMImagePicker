//
//  VMIPVideoFrameCollectionControllerViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoFrameCollectionControllerViewModel.h"

#import <Photos/PHImageManager.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionControllerViewModel.h>

@interface VMIPVideoFrameCollectionControllerViewModel ()
@property (assign, nonatomic) PHImageRequestID requestId;
@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;
@end

@implementation VMIPVideoFrameCollectionControllerViewModel



- (void)setDelegate:(id<IVMIPVideoFrameCollectionControllerViewModelDelegate>)delegate {
    [super setDelegate:delegate];
}

- (void)loadVideoCompletion:(void (^ _Nonnull)(NSError *error))completion {
    @weakify(self);
    [self.imageGenerator cancelAllCGImageGeneration];
    PHAsset *asset = [self.delegate assetOfViewModel:self];
    PHVideoRequestOptions *option = PHVideoRequestOptions.new;
    option.version = PHVideoRequestOptionsVersionCurrent;
    option.networkAccessAllowed = YES;
    self.requestId = [PHImageManager.defaultManager requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        @strongify(self);
        if (self.requestId != [info[PHImageResultRequestIDKey] intValue]) {
            return;
        }
        NSError *error = info[PHImageErrorKey];
        if (!error) {
            if ([info[PHImageCancelledKey] boolValue]) {
                error = [NSError errorWithDomain:@"User Cancel Load Video!" code:0 userInfo:nil];
            } else {
                AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                imageGenerator.appliesPreferredTrackTransform = YES;
                imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
                imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
                imageGenerator.maximumSize = CGSizeMake(640, 360);
                
                AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
                CGFloat frameRate = videoTrack.nominalFrameRate;
                NSMutableArray *frameFragments = NSMutableArray.new;
                NSTimeInterval duration = asset.duration.value / asset.duration.timescale;
                NSTimeInterval interval = (videoTrack.minFrameDuration.value / videoTrack.minFrameDuration.timescale);
                uint64_t frames = duration / interval;
                NSTimeInterval frameInterval = duration / 100;
                for (NSInteger index = 0; index < 100; ++index) {
                    NSValue *frameFragment = [NSValue valueWithCMTime:CMTimeMake(frameInterval * index, frameRate)];
                    [frameFragments addObject:frameFragment];
                }
                
                [imageGenerator generateCGImagesAsynchronouslyForTimes:frameFragments completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
                    @strongify(self);
                    if (!image) {
                        NSAssert(!error, @"Generate Image Error %@", error);
                        return;
                    }
                    UIImage *frameImage = [[UIImage alloc] initWithCGImage:image];
                    if (NSThread.isMainThread) {
                        [self addFrameImage:frameImage];
                    } else {
                        [self performSelector:@selector(addFrameImage:) onThread:NSThread.mainThread withObject:frameImage waitUntilDone:NO];
                    }
                }];
                self.imageGenerator = imageGenerator;
            }
        }
        if (error) {
            completion(error);
        }
        self.requestId = PHInvalidImageRequestID;
    }];
}

#pragma mark - Private

- (void)addFrameImage:(UIImage *)frameImage {
    
}

@end
