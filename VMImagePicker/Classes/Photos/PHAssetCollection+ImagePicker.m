//
//  PHAssetCollection+ImagePicker.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/15.
//

#import "PHAssetCollection+ImagePicker.h"

@implementation PHAssetCollection (ImagePicker)

+ (NSArray<__kindof NSNumber *> *)collectionTypes {
    static NSArray *collectionTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionTypes = @[
            @(PHAssetCollectionTypeAlbum),
            @(PHAssetCollectionTypeSmartAlbum),
        ];
    });
    return collectionTypes;
}

+ (NSArray<__kindof NSNumber *> *)collectionSubtypes {
    static NSMutableArray *collectionSubtypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionSubtypes = NSMutableArray.new;
        // PHAssetCollectionTypeAlbum regular subtypes
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumRegular)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumSyncedEvent)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumSyncedFaces)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumSyncedAlbum)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumImported)];
        // PHAssetCollectionTypeAlbum shared subtypes
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumMyPhotoStream)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeAlbumCloudShared)];
        // PHAssetCollectionTypeSmartAlbum subtypes
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumGeneric)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumVideos)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumFavorites)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumTimelapses)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumAllHidden)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumBursts)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumSlomoVideos)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumUserLibrary)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumSelfPortraits)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumScreenshots)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumDepthEffect)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumLivePhotos)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumAnimated)];
        [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumLongExposures)];
        if (@available(iOS 13.0, *)) {
            [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumUnableToUpload)];
        }
        if (@available(iOS 15.0, *)) {
            [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumRAW)];
            [collectionSubtypes addObject:@(PHAssetCollectionSubtypeSmartAlbumCinematic)];
        }
    });
    return collectionSubtypes;
}

+ (NSArray<__kindof PHCollection *> *)fetchAllAssetCollectionsWithOptions:(PHFetchOptions *)options {
    NSMutableArray<__kindof PHFetchResult<__kindof PHAssetCollection *> *> *fetchResults = NSMutableArray.new;
    // PHAssetCollectionTypeAlbum regular subtypes
    PHAssetCollectionSubtype albumRegularSubTypes[] = {
        PHAssetCollectionSubtypeAlbumRegular,
        PHAssetCollectionSubtypeAlbumSyncedEvent,
        PHAssetCollectionSubtypeAlbumSyncedFaces,
        PHAssetCollectionSubtypeAlbumSyncedAlbum,
        PHAssetCollectionSubtypeAlbumImported,
        PHAssetCollectionSubtypeAny,
    };
    for (int index = 0; index < sizeof(albumRegularSubTypes) / sizeof(PHAssetCollectionSubtype); ++index) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:albumRegularSubTypes[index] options:options]];
    }
    // PHAssetCollectionTypeAlbum shared subtypes
    PHAssetCollectionSubtype albumSharedSubTypes[] = {
        PHAssetCollectionSubtypeAlbumMyPhotoStream,
        PHAssetCollectionSubtypeAlbumCloudShared,
    };
    for (int index = 0; index < sizeof(albumSharedSubTypes) / sizeof(PHAssetCollectionSubtype); ++index) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:albumSharedSubTypes[index] options:options]];
    }
    // PHAssetCollectionTypeSmartAlbum subtypes
    PHAssetCollectionSubtype albumSmartSubTypes[] = {
        PHAssetCollectionSubtypeSmartAlbumGeneric,
        PHAssetCollectionSubtypeSmartAlbumPanoramas,
        PHAssetCollectionSubtypeSmartAlbumVideos,
        PHAssetCollectionSubtypeSmartAlbumFavorites,
        PHAssetCollectionSubtypeSmartAlbumTimelapses,
        PHAssetCollectionSubtypeSmartAlbumAllHidden,
        PHAssetCollectionSubtypeSmartAlbumRecentlyAdded,
        PHAssetCollectionSubtypeSmartAlbumBursts,
        PHAssetCollectionSubtypeSmartAlbumSlomoVideos,
        PHAssetCollectionSubtypeSmartAlbumUserLibrary,
        PHAssetCollectionSubtypeSmartAlbumSelfPortraits,
        PHAssetCollectionSubtypeSmartAlbumScreenshots,
        PHAssetCollectionSubtypeSmartAlbumDepthEffect,
        PHAssetCollectionSubtypeSmartAlbumLivePhotos,
        PHAssetCollectionSubtypeSmartAlbumAnimated,
        PHAssetCollectionSubtypeSmartAlbumLongExposures,
        PHAssetCollectionSubtypeAny,
    };
    for (int index = 0; index < sizeof(albumSmartSubTypes) / sizeof(PHAssetCollectionSubtype); ++index) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:albumSmartSubTypes[index] options:options]];
    }
    if (@available(iOS 15.0, *)) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRAW options:nil]];
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumCinematic options:nil]];
    }
    if (@available(iOS 13.0, *)) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUnableToUpload options:nil]];
    }
    NSMutableArray<__kindof PHCollection *> *result = NSMutableArray.new;
    NSMutableDictionary<__kindof NSString *, __kindof PHAssetCollection *> *assetCollections = NSMutableDictionary.new;
    for (PHFetchResult<__kindof PHAssetCollection *> *fetchResult in fetchResults) {
        for (PHAssetCollection *assetCollection in fetchResult) {
            if (!assetCollections[assetCollection.localIdentifier]) {
                assetCollections[assetCollection.localIdentifier] = assetCollection;
                [result addObject:assetCollection];
            }
#ifdef DEBUG
            else {
                NSLog(@"Repeat album %@ assetCollectionType=%ld/%ld", assetCollection.localizedTitle, assetCollection.assetCollectionType, assetCollection.assetCollectionSubtype);
            }
#endif // #ifdef DEBUG
        }
    }
    return result;
}
+ (NSArray<__kindof PHCollection *> *)fetchAssetCollectionsWithTypes:(NSArray<__kindof NSNumber *> *)types
                                                            subtypes:(NSArray<__kindof NSNumber *> *)subtypes
                                                             options:(PHFetchOptions * _Nullable)options {
    NSAssert(types.count == subtypes.count, @"types & subtype are not same count %ld != %ld!", types.count, subtypes.count);
    NSMutableArray<__kindof PHFetchResult<__kindof PHAssetCollection *> *> *fetchResults = NSMutableArray.new;
    for (NSInteger index = 0; index < types.count; ++index) {
        [fetchResults addObject:
         [PHAssetCollection fetchAssetCollectionsWithType:types[index].integerValue subtype:subtypes[index].integerValue options:nil]];
    }
    NSMutableArray<__kindof PHCollection *> *result = NSMutableArray.new;
    NSMutableDictionary<__kindof NSString *, __kindof PHAssetCollection *> *assetCollections = NSMutableDictionary.new;
    for (PHFetchResult<__kindof PHAssetCollection *> *fetchResult in fetchResults) {
        for (PHAssetCollection *assetCollection in fetchResult) {
            if (!assetCollections[assetCollection.localIdentifier]) {
                assetCollections[assetCollection.localIdentifier] = assetCollection;
                [result addObject:assetCollection];
            }
#ifdef DEBUG
            else {
                NSLog(@"Repeat album %@ assetCollectionType=%ld/%ld", assetCollection.localizedTitle, assetCollection.assetCollectionType, assetCollection.assetCollectionSubtype);
            }
#endif // #ifdef DEBUG
        }
    }
    return result;
}

@end
