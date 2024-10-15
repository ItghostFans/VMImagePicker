//
//  VMImagePickerQueue.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/15.
//

#import <Foundation/Foundation.h>

#import "VMImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMImagePickerQueue : NSObject

- (instancetype)initWithImagePickers:(NSArray<__kindof VMImagePicker *> *)imagePickers;


/// 有序地获取资源。以避免直接全部获取，导致内存吃紧。
/// - Parameter block: 每个VMImagePicker获取完后，都会回调1次。
- (void)enumerateAssetsUsingBlock:(VMImagePickerGetAssetBlock _Nonnull)block;

@end

NS_ASSUME_NONNULL_END
