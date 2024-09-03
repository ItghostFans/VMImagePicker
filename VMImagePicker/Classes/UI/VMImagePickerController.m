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
    @weakify(self);
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
    titleTextAttributes[NSFontAttributeName] = [self.style fontWithThemeFonts:self.style.navigationBarBackTitleFonts];
    titleTextAttributes[NSForegroundColorAttributeName] = [self.style colorWithThemeColors:self.style.navigationBarBackTitleColors];
    backButtonAppearance.normal.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarBackTitleFonts state:(UIControlStateNormal)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarBackTitleColors state:(UIControlStateNormal)],
    };
//    backButtonAppearance.normal.backgroundImage = [self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateNormal)];
    backButtonAppearance.highlighted.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarBackTitleFonts state:(UIControlStateHighlighted)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarBackTitleColors state:(UIControlStateHighlighted)],
    };
//    backButtonAppearance.highlighted.backgroundImage = [self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateHighlighted)];
    backButtonAppearance.disabled.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarBackTitleFonts state:(UIControlStateDisabled)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarBackTitleColors state:(UIControlStateDisabled)],
    };
//    backButtonAppearance.disabled.backgroundImage = [self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateDisabled)];
    backButtonAppearance.focused.titleTextAttributes = @{
        NSFontAttributeName: [self.style fontWithControlThemeFonts:self.style.navigationBarBackTitleFonts state:(UIControlStateFocused)],
        NSForegroundColorAttributeName: [self.style colorWithControlThemeColors:self.style.navigationBarBackTitleColors state:(UIControlStateFocused)],
    };
//    backButtonAppearance.focused.backgroundImage = [self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateFocused)];
    appearance.backButtonAppearance = backButtonAppearance;
    
    [appearance setBackIndicatorImage:[self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateNormal)]
                  transitionMaskImage:[self.style imageWithControlThemeImages:self.style.navigationBarBackImages state:(UIControlStateNormal)]];
    
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
