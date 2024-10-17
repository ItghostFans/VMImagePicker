//
//  VMImagePicker+Mp4.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/14.
//

#import "VMImagePicker+Mp4.h"
#import "VMImagePicker+Private.h"

#import <ReactiveObjC/ReactiveObjC.h>

@implementation VMImagePicker (Mp4)

- (NSString *)mp4Directory {
    return [self getDirectory:@"Mp4"];
}

- (void)getMp4AssetCallback:(VMImagePickerGetAssetBlock)callback {
    @weakify(self);
    PHVideoRequestOptions* option = PHVideoRequestOptions.new;
    option.networkAccessAllowed = YES;
    if (self.config.original) {
        option.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    } else {
        option.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
    }
    NSString *presetQuality;
    switch (option.deliveryMode) {
        case PHVideoRequestOptionsDeliveryModeHighQualityFormat: {
            presetQuality = AVAssetExportPresetHighestQuality;
            break;
        }
        case PHVideoRequestOptionsDeliveryModeMediumQualityFormat: {
            presetQuality = AVAssetExportPresetMediumQuality;
            break;
        }
        default: {
            presetQuality = AVAssetExportPresetLowQuality;
            break;
        }
    }
    
    [PHImageManager.defaultManager requestAVAssetForVideo:self.asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        @strongify(self);
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
        NSURL *assetUrl = ((AVURLAsset *)asset).URL;
        if ([presets containsObject:presetQuality]) {
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetQuality];
            session.shouldOptimizeForNetworkUse = YES;
            
            NSArray *supportedTypeArray = session.supportedFileTypes;
            if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
                session.outputFileType = AVFileTypeMPEG4;
            } else
            if (!supportedTypeArray.count) {
                self.error = [NSError errorWithDomain:[NSString stringWithFormat:@"Not Support Mp4 %@", presetQuality] code:-1 userInfo:nil];
                callback(self.asset, self.config, self);
                return;
            } else {
                session.outputFileType = [supportedTypeArray objectAtIndex:0];
            }
            
            if (assetUrl.lastPathComponent) {
                session.outputURL = [NSURL fileURLWithPath:[self.mp4Directory stringByAppendingPathComponent:assetUrl.lastPathComponent]];
            }

            [session exportAsynchronouslyWithCompletionHandler:^(void) {
                @strongify(self);
                self.object = session.outputURL.relativePath;
                callback(self.asset, self.config, self);
            }];
        } else {
            self.error = [NSError errorWithDomain:[NSString stringWithFormat:@"Not Support Preset %@", presetQuality] code:-1 userInfo:nil];
            callback(self.asset, self.config, self);
        }
    }];
}

@end
