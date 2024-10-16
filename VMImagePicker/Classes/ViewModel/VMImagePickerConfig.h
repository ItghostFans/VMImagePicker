//
//  VMImagePickerConfig.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VMImagePickerConfig : NSObject

@property (assign, nonatomic) BOOL original;                // Default NO 缩略图 YES 原图，不太建议一直使用原图，避免
@property (assign, nonatomic) CGSize preferredSize;         // 预设尺寸。original==NO时使用。
@property (assign, nonatomic) CGFloat compressionQuality;   // 图片压缩比。original==NO时使用。

@property (strong, nonatomic) NSString *directory;          // 生成文件的路径，由外部提供。默认Caches/VMImagePicker

@end

NS_ASSUME_NONNULL_END
