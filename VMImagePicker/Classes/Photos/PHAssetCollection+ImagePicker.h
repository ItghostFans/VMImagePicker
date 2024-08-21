//
//  PHAssetCollection+ImagePicker.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/15.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PHAssetCollectionSubtypeUndefined) {
    PHAssetCollectionSubtypeUndefinedRecentlyDeleted    = 1000000201,   // 最近删除
    PHAssetCollectionSubtypeUndefinedSpatial            = 1000000217,   // 这个还不知道是啥
};

@interface PHAssetCollection (ImagePicker)

+ (NSArray<__kindof PHCollection *> *)fetchAllAssetCollectionsWithOptions:(PHFetchOptions * _Nullable)options;
+ (NSArray<__kindof PHCollection *> *)fetchAssetCollectionsWithTypes:(NSArray<__kindof NSNumber *> *)types
                                                            subtypes:(NSArray<__kindof NSNumber *> *)subtypes
                                                             options:(PHFetchOptions * _Nullable)options;

@end

NS_ASSUME_NONNULL_END
