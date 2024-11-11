//
//  VMIPEditVideoToolBarView.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMIPEditVideoToolBarView : UIView

@property (weak, nonatomic, readonly) UIButton *doneButton;

@property (weak, nonatomic) VMImagePickerStyle *style;

@end

NS_ASSUME_NONNULL_END
