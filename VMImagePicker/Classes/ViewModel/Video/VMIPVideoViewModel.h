//
//  VMIPVideoViewModel.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/27.
//

#import <Foundation/Foundation.h>

#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class AVPlayerItem;
@class CLLocation;

@interface VMIPVideoViewModel : NSObject

@property (weak, nonatomic, readonly) PHAsset *asset;

- (instancetype)initWithAsset:(PHAsset *)asset;

- (PHImageRequestID)loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
                 completion:(void (^ _Nonnull)(NSError *error, AVPlayerItem *playerItem))completion;

- (PHImageRequestID)exportVideoPreset:(AVCaptureSessionPreset)videoPreset
                            timeRange:(CMTimeRange)timeRange
                            directory:(NSString *)directory
                              loading:(void (^ _Nullable)(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info))loading
                           completion:(void (^ _Nonnull)(NSError * _Nullable error, NSString * _Nullable videoPath))completion;

- (void)saveSystemVideoPath:(NSString * _Nonnull)videoPath
                   location:(CLLocation * _Nullable)location
                 completion:(void (^ _Nonnull)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
