//
//  VMIPEditVideoCropView.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMIPEditVideoCropView : UIView

@property (assign, nonatomic, readonly) CGFloat barWidth;
@property (weak, nonatomic, nullable) VMImagePickerStyle *style;
@property (assign, nonatomic, readonly) CGFloat begin;
@property (assign, nonatomic, readonly) CGFloat end;

@end

NS_ASSUME_NONNULL_END
