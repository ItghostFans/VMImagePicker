//
//  VMIPPreviewToolBarView.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMIPPreviewToolBarView : UIView

@property (weak, nonatomic, readonly) UIButton *editButton;
@property (weak, nonatomic, readonly) UIButton *originalButton;
@property (weak, nonatomic, readonly) UIButton *doneButton;

@property (weak, nonatomic) VMImagePickerStyle *style;

@end

NS_ASSUME_NONNULL_END
