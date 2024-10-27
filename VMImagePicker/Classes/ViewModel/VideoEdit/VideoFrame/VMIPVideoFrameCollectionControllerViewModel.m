//
//  VMIPVideoFrameCollectionControllerViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoFrameCollectionControllerViewModel.h"
#import "VMIPVideoFrameCellViewModel.h"

#import <Photos/PHImageManager.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewModel/CollectionControllerViewModel.h>
#import <ViewModel/CollectionViewModel.h>
#import <ViewModel/UICollectionView+ViewModel.h>

@interface VMIPVideoFrameCollectionControllerViewModel ()
@property (assign, nonatomic) PHImageRequestID requestId;
@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;
@end

@implementation VMIPVideoFrameCollectionControllerViewModel

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

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
        NSNumber *requestId = info[PHImageResultRequestIDKey];
        NSError *error = info[PHImageErrorKey];
        if (!error) {
            if ([info[PHImageCancelledKey] boolValue]) {
                error = [NSError errorWithDomain:@"User Cancel Load Video!" code:0 userInfo:nil];
            } else {
                RACTuple *tuple = [RACTuple tupleWithObjects:completion, asset, requestId, nil];
                if (NSThread.isMainThread) {
                    [self loadFramesAssetTuple:tuple];
                } else {
                    [self performSelectorOnMainThread:@selector(loadFramesAssetTuple:) withObject:tuple waitUntilDone:NO];
                }
            }
        }
        if (error) {
            RACTuple *tuple = [RACTuple tupleWithObjects:completion, error, requestId, nil];
            if (NSThread.isMainThread) {
                [self loadFramesErrorTuple:tuple];
            } else {
                [self performSelectorOnMainThread:@selector(loadFramesErrorTuple:) withObject:tuple waitUntilDone:NO];
            }
        }
    }];
}

#pragma mark - Private

- (void)loadFramesAssetTuple:(RACTuple *)tuple {
    @weakify(self);
    RACTupleUnpack(void (^completion)(NSError *error), AVAsset *asset, NSNumber *requestId) = tuple;
    if (self.requestId != requestId.intValue) {
        return;
    }
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    CGSize size = self.collectionViewModel.collectionView.frame.size;
    CGFloat vFactor = size.height / asset.naturalSize.height;
    CGFloat hFactor = size.width / asset.naturalSize.width;
    CGFloat factor = MIN(hFactor, vFactor);
    imageGenerator.maximumSize = CGSizeMake(asset.naturalSize.width * factor, asset.naturalSize.height * factor);
    
    NSTimeInterval duration = asset.duration.value / asset.duration.timescale;
    NSTimeInterval frameInterval = duration / (self.videoCropFrameCount - 1); // 要获取第一帧和最后一帧
    [self.collectionViewModel.collectionView performBatchUpdates:^{
        @strongify(self);
//        AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
//        CGFloat frameRate = videoTrack.nominalFrameRate;
        for (uint64_t index = 0; index < self.videoCropFrameCount; ++index) {
            VMIPVideoFrameCellViewModel *cellViewModel = VMIPVideoFrameCellViewModel.new;
            cellViewModel.frameTime = CMTimeMakeWithSeconds(frameInterval * index, 1000);
            cellViewModel.imageGenerator = imageGenerator;
            cellViewModel.videoCropFrameCount = self.videoCropFrameCount;
            [self.collectionViewModel.sectionViewModels[0] addViewModel:cellViewModel];
        }
    } completion:^(BOOL) {
    } animationsEnabled:NO];
    self.imageGenerator = imageGenerator;
    completion(nil);
}

- (void)loadFramesErrorTuple:(RACTuple *)tuple {
    RACTupleUnpack(void (^completion)(NSError *error), NSError *error, NSNumber *requestId) = tuple;
    if (self.requestId != requestId.intValue) {
        return;
    }
    completion(error);
}

@end
