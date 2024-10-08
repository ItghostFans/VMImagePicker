//
//  VMImagePickerController.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import "VMImagePickerController.h"
#import "VMImagePicker+Private.h"
#import "VMImagePickerStyle.h"
#import "VMImagePickerConfig.h"
#import "VMIPAssetCollectionControllerViewModel.h"
#import "VMIPPreviewCollectionControllerViewModel.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VMImagePickerController () <IVMIPAssetCollectionControllerViewModelDelegate, IVMIPPreviewCollectionControllerViewModelDelegate>
@property (strong, nonatomic) VMImagePickerStyle *style;
@property (strong, nonatomic) VMImagePickerConfig *config;
@property (assign, nonatomic) VMImagePickerState state;
@end

@implementation VMImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleUI];
}

- (void)dealloc {
    switch (_state) {
        case VMImagePickerStateNone: {
            if ([_imagePickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
                [_imagePickerDelegate imagePickerControllerDidCancel:self];
            }
            break;
        }
        default: {
            break;
        }
    }
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
    
    self.toolbar.translucent = NO;
    self.toolbar.tintColor = UIColor.clearColor;
    self.toolbar.backgroundColor = UIColor.clearColor;
    self.toolbar.standardAppearance.shadowColor = UIColor.clearColor;
    self.toolbar.standardAppearance.shadowImage = nil;
    self.toolbar.standardAppearance.backgroundColor = UIColor.clearColor;
    self.toolbar.standardAppearance.backgroundEffect = nil;
    self.toolbar.scrollEdgeAppearance = self.toolbar.standardAppearance;
    
    UIImageView *toolThemeView = UIImageView.new;
    toolThemeView.backgroundColor = [self.style colorWithThemeColors:self.style.toolBkgColors];
    [self.toolbar insertSubview:toolThemeView atIndex:0];
    [toolThemeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.toolbar);
        make.bottom.equalTo(self.toolbar).offset(0.0f);
    }];
    @weakify(toolThemeView, self);
    [[self rac_signalForSelector:@selector(viewSafeAreaInsetsDidChange)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(toolThemeView, self);
        [toolThemeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.toolbar).offset(self.view.safeAreaInsets.bottom);
        }];
    }];
    
    [[self.toolbar rac_signalForSelector:@selector(didAddSubview:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(toolThemeView);
        [toolThemeView.superview sendSubviewToBack:toolThemeView];
    }];
}

#pragma mark - Getter

- (VMImagePickerStyle *)style {
    if (!_style) {
        _style = VMImagePickerStyle.new;
    }
    return _style;
}

- (VMImagePickerConfig *)config {
    if (!_config) {
        _config = VMImagePickerConfig.new;
    }
    return _config;
}

#pragma mark - IVMIPAssetCollectionControllerViewModelDelegate, IVMIPPreviewCollectionControllerViewModelDelegate

- (void)viewModel:(id)viewModel didSelectedAssets:(NSArray<__kindof PHAsset *> *)assets {
    NSMutableArray<__kindof VMImagePicker *> *imagePickers = [NSMutableArray arrayWithCapacity:assets.count];
    for (PHAsset *asset in assets) {
        [imagePickers addObject:[[VMImagePicker alloc] initWithAsset:asset config:self.config]];
    }
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        [self.imagePickerDelegate imagePickerController:self didFinishPickingMediaWithInfo:@{
            VMImagePickersKey: imagePickers
        }];
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    self.state = VMImagePickerStateDone;
}

@end

UIImagePickerControllerInfoKey const VMImagePickersKey = @"VMImagePickersKey";
