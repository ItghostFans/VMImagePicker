//
//  VMIPNavigationBarStyle.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMImagePickerStyle;

@interface VMIPNavigationBarStyle : NSObject

- (instancetype)initWithController:(UIViewController *)controller;

- (UIButton *)formatBackButtonWithStyle:(VMImagePickerStyle *)style;

@end

NS_ASSUME_NONNULL_END
