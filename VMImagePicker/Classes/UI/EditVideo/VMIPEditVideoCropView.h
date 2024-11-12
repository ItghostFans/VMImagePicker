//
//  VMIPEditVideoCropView.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;
@class VMIPEditVideoCropView;

@protocol VMIPEditVideoCropViewDelegate <NSObject>
- (void)cropView:(VMIPEditVideoCropView *)cropView tapStartBegin:(CGFloat)begin;
- (void)cropView:(VMIPEditVideoCropView *)cropView tapEndBegin:(CGFloat)begin;
- (void)cropView:(VMIPEditVideoCropView *)cropView tapStartEnd:(CGFloat)end;
- (void)cropView:(VMIPEditVideoCropView *)cropView tapEndEnd:(CGFloat)end;
@end

@interface VMIPEditVideoCropView : UIView

@property (assign, nonatomic, readonly) CGFloat barWidth;
@property (assign, nonatomic, readonly) CGFloat begin;  // KVO
@property (assign, nonatomic, readonly) CGFloat end;    // KVO

@property (weak, nonatomic, nullable) VMImagePickerStyle *style;
@property (weak, nonatomic, nullable) id<VMIPEditVideoCropViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
