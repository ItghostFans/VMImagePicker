//
//  VMIPNavigationBarStyle.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/5.
//

#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerStyle.h"

@interface VMIPNavigationBarStyle ()
@property (weak, nonatomic) UIViewController *controller;
@end

@implementation VMIPNavigationBarStyle

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [self init]) {
        _controller = controller;
    }
    return self;
}

- (UIButton *)formatBackButtonWithStyle:(VMImagePickerStyle *)style {
    UIButton *backButton = UIButton.new;
    if (self.controller.navigationController.navigationBar.topItem != self.controller.navigationItem) {
        [backButton setTitle:self.controller.navigationController.navigationBar.topItem.title forState:(UIControlStateNormal)];
    }
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackImages state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackImages state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackImages state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackImages state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    self.controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onBackClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return backButton;
}

#pragma mark - Actions

- (void)onBackClicked:(id)sender {
    if (self.controller.navigationController) {
        if (self.controller.navigationController.viewControllers.count == 1) {
            if (self.controller.navigationController.navigationController) {
                [self.controller.navigationController.navigationController popViewControllerAnimated:YES];
            } else
            if (self.controller.navigationController.presentingViewController) {
                [self.controller.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
            } else
            if (self.controller.navigationController.parentViewController) {
                [self.controller.navigationController.view removeFromSuperview];
                [self.controller.navigationController removeFromParentViewController];
            }
        } else {
            [self.controller.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
