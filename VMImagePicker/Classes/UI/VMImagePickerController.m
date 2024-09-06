//
//  VMImagePickerController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import "VMImagePickerController.h"
#import "VMImagePickerStyle.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface VMImagePickerController ()
@property (strong, nonatomic) VMImagePickerStyle *style;
@end

@implementation VMImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleUI];
}

- (void)styleUI {
    self.view.backgroundColor = [self.style colorWithThemeColors:self.style.bkgColors];
    UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
    if (self.navigationBar.isTranslucent) {
        appearance.backgroundColor = [self.style colorWithThemeColors:self.style.navigationBarBkgColors];
    }
    NSMutableDictionary *titleTextAttributes = NSMutableDictionary.new;
    titleTextAttributes[NSFontAttributeName] = [self.style fontWithThemeFonts:self.style.navigationBarTitleFonts];
    titleTextAttributes[NSForegroundColorAttributeName] = [self.style colorWithThemeColors:self.style.navigationBarTitleColors];
    appearance.titleTextAttributes = titleTextAttributes;
    
    UIBarButtonItemAppearance *backButtonAppearance = UIBarButtonItemAppearance.new;
    backButtonAppearance.normal.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarButtonTitleFonts state:(UIControlStateNormal)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarButtonTitleColors state:(UIControlStateNormal)],
    };
    backButtonAppearance.highlighted.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarButtonTitleFonts state:(UIControlStateHighlighted)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarButtonTitleColors state:(UIControlStateHighlighted)],
    };
    backButtonAppearance.disabled.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarButtonTitleFonts state:(UIControlStateDisabled)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarButtonTitleColors state:(UIControlStateDisabled)],
    };
    backButtonAppearance.focused.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarButtonTitleFonts state:(UIControlStateFocused)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarButtonTitleColors state:(UIControlStateFocused)],
    };
    appearance.buttonAppearance = backButtonAppearance;
    self.navigationBar.standardAppearance = appearance;
    self.navigationBar.scrollEdgeAppearance = appearance;
}

#pragma mark - Getter

- (VMImagePickerStyle *)style {
    if (!_style) {
        _style = VMImagePickerStyle.new;
    }
    return _style;
}

@end