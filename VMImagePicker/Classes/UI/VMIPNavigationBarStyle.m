//
//  VMIPNavigationBarStyle.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/5.
//

#import "VMIPNavigationBarStyle.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMIPNavigationBarStyle ()
@property (weak, nonatomic) UIViewController *controller;
@property (weak, nonatomic) VMImagePickerController *imagePickerController;
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
    if (self.imagePickerController.navigationBar.topItem != self.controller.navigationItem) {
        [backButton setTitle:self.imagePickerController.navigationBar.topItem.title forState:(UIControlStateNormal)];
    }
    // Image
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackButtonImages state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackButtonImages state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackButtonImages state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [backButton setImage:[style imageWithControlThemeImages:style.navigationBarBackButtonImages state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    self.controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    // Title Color
    [backButton setTitleColor:[style colorWithControlThemeColors:style.navigationBarButtonTitleColors state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [backButton setTitleColor:[style colorWithControlThemeColors:style.navigationBarButtonTitleColors state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [backButton setTitleColor:[style colorWithControlThemeColors:style.navigationBarButtonTitleColors state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [backButton setTitleColor:[style colorWithControlThemeColors:style.navigationBarButtonTitleColors state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    self.controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    // Title Font
    @weakify(backButton, style);
    [[RACObserve(backButton, state) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        UIControlState state = [x unsignedIntegerValue];
        @strongify(backButton, style);
        backButton.titleLabel.font = [style fontWithControlThemeFonts:style.navigationBarButtonTitleFonts state:state];
    }];
    [backButton addTarget:self action:@selector(onBackClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    return backButton;
}

#pragma mark - Getter

- (VMImagePickerController *)imagePickerController {
    return (VMImagePickerController *)self.controller.navigationController;
}

#pragma mark - Actions

- (void)onBackClicked:(id)sender {
    if (self.imagePickerController) {
        if (self.imagePickerController.viewControllers.count == 1) {
            if (self.imagePickerController.navigationController) {
                [self.imagePickerController.navigationController popViewControllerAnimated:YES];
                [self cancel];
            } else
            if (self.imagePickerController.presentingViewController) {
                [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
                    [self cancel];
                }];
            } else
            if (self.imagePickerController.parentViewController) {
                [self.imagePickerController.view removeFromSuperview];
                [self.imagePickerController removeFromParentViewController];
                [self cancel];
            }
        } else {
            [self.imagePickerController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Private

- (void)cancel {
    if ([self.imagePickerController.imagePickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.imagePickerController.imagePickerDelegate imagePickerControllerDidCancel:self.imagePickerController];
    }
}

@end
