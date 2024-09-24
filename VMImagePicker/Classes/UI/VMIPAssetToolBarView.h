//
//  VMIPAssetToolBarView.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMIPAssetToolBarView : UIView

@property (weak, nonatomic, readonly) UIButton *previewButton;
@property (weak, nonatomic, readonly) UIButton *originalButton;
@property (weak, nonatomic, readonly) UIButton *doneButton;

@property (strong, nonatomic) VMImagePickerStyle *style;

@end

NS_ASSUME_NONNULL_END
