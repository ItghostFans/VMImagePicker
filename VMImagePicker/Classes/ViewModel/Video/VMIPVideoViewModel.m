//
//  VMIPVideoViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/27.
//

#import "VMIPVideoViewModel.h"

#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHAssetChangeRequest.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPVideoViewModel ()
@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation VMIPVideoViewModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [self init]) {
        _requestId = PHInvalidImageRequestID;
        _asset = asset;
    }
    return self;
}

- (PHImageRequestID)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
     completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion {
    @weakify(self);
    if (_requestId != PHInvalidImageRequestID) {
        [PHImageManager.defaultManager cancelImageRequest:_requestId];
        _requestId = PHInvalidImageRequestID;
    }
    PHVideoRequestOptions *option = PHVideoRequestOptions.new;
    option.networkAccessAllowed = YES;
    option.progressHandler = loading;
    _requestId = [PHImageManager.defaultManager requestPlayerItemForVideo:_asset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        @strongify(self);
        if (self.requestId != [info[PHImageResultRequestIDKey] intValue]) {
            return;
        }
        NSError *error = info[PHImageErrorKey];
        if (!error) {
            if ([info[PHImageCancelledKey] boolValue]) {
                error = [NSError errorWithDomain:@"User Cancel Play Video!" code:0 userInfo:nil];
            } else {
            }
        }
        completion(error, playerItem);
        self.requestId = PHInvalidImageRequestID;
    }];
    return _requestId;
}

- (PHImageRequestID)exportVideoPreset:(AVCaptureSessionPreset)videoPreset
                            timeRange:(CMTimeRange)timeRange
                            directory:(NSString *)directory
                              loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
                           completion:(void (^ _Nonnull)(NSError * _Nullable error, NSString * _Nullable videoPath))completion {
    @weakify(self);
    if (_requestId != PHInvalidImageRequestID) {
        [PHImageManager.defaultManager cancelImageRequest:_requestId];
        _requestId = PHInvalidImageRequestID;
    }
    PHVideoRequestOptions *option = PHVideoRequestOptions.new;
    option.networkAccessAllowed = YES;
    option.progressHandler = loading;
    self.requestId = [PHImageManager.defaultManager requestAVAssetForVideo:_asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
        NSError *error = nil;
        if (![presets containsObject:videoPreset]) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"Not Support Preset %@", videoPreset] code:AVAssetExportSessionStatusUnknown userInfo:nil];
            self.requestId = PHInvalidImageRequestID;
            completion(error, nil);
            return;
        }
        AVAssetExportSession *videoExportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:videoPreset];
        videoExportSession.shouldOptimizeForNetworkUse = true;
        if (!CMTimeRangeEqual(timeRange, kCMTimeRangeZero)) {
            videoExportSession.timeRange = timeRange;
        }
        NSArray *supportedFileTypes = videoExportSession.supportedFileTypes;
        if ([supportedFileTypes containsObject:AVFileTypeMPEG4]) {
            videoExportSession.outputFileType = AVFileTypeMPEG4;
        } else if (supportedFileTypes.count == 0) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"Not Support Export %@", videoPreset] code:AVAssetExportSessionStatusUnknown userInfo:nil];
            self.requestId = PHInvalidImageRequestID;
            completion(error, nil);
            return;
        } else {
            videoExportSession.outputFileType = supportedFileTypes.firstObject;
        }
        
        NSURL *url = [(AVURLAsset *)asset URL];
        NSString *fileNameExt = url.lastPathComponent;
        NSString *fileName = [fileNameExt componentsSeparatedByString:@"."].firstObject;
        fileName = [NSString stringWithFormat:@"%@-%llu", fileName, [NSDate.date timeIntervalSince1970] * 1000];
        NSString *exportPath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:url.pathExtension];
        exportPath = [exportPath stringByAppendingPathExtension:@"tmp"];
        videoExportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        @weakify(videoExportSession);
        [videoExportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            @strongify(videoExportSession);
            NSError *error;
            NSString *videoPath;
            switch (videoExportSession.status) {
                case AVAssetExportSessionStatusUnknown: {
                    error = [NSError errorWithDomain:@"Export Failed!" code:videoExportSession.status userInfo:nil];
                    break;
                }
                case AVAssetExportSessionStatusCompleted: {
                    videoPath = [exportPath stringByDeletingPathExtension];
                    [NSFileManager.defaultManager moveItemAtPath:exportPath toPath:videoPath error:&error];
                    break;
                }
                case AVAssetExportSessionStatusFailed: {
                    error = [NSError errorWithDomain:@"Export Failed!" code:videoExportSession.status userInfo:nil];
                    break;
                }
                case AVAssetExportSessionStatusCancelled: {
                    error = [NSError errorWithDomain:@"Export Canceled!" code:videoExportSession.status userInfo:nil];
                    break;
                }
                default: {
                    break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.requestId = PHInvalidImageRequestID;
                if (error) {
                    completion(error, nil);
                } else {
                    completion(error, videoPath);
                }
            });
        }];
    }];
    return self.requestId;
}

- (void)saveSystemVideoPath:(NSString * _Nonnull)videoPath
                   location:(CLLocation * _Nullable)location
                 completion:(void (^ _Nonnull)(NSError * _Nullable error))completion {
//    __block NSString *localIdentifier;
    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:videoPath]];
//        localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
        if (location) {
            request.location = location;
        }
        request.creationDate = NSDate.date;
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }];
}

@end
