//
//  VMImagePickerStyle.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import "VMImagePickerStyle.h"

#import <ReactiveObjC/ReactiveObjC.h>

/// RGB16进制格式的颜色。
/// - Parameter rgb: 0xRRGGBB
UIColor * RGB_HEX_COLOR(int32_t rgb) {
    return [UIColor colorWithRed:((rgb >> 16) & 0xFF) / 255.0f
                           green:((rgb >> 8) & 0xFF) / 255.0f
                            blue:(rgb & 0xFF) / 255.0f
                           alpha:1.0f];
}

/// RGBA16进制格式的颜色。
/// - Parameter rgba: 0xRRGGBBAA
UIColor * RGBA_HEX_COLOR(int32_t rgba) {
    return [UIColor colorWithRed:((rgba >> 24) & 0xFF) / 255.0f
                           green:((rgba >> 16) & 0xFF) / 255.0f
                            blue:((rgba >> 8) & 0xFF) / 255.0f
                           alpha:(rgba & 0xFF) / 255.0f];
}

@interface VMImagePickerStyle ()
@property (strong, nonatomic) NSBundle *bundle;
@end

@implementation VMImagePickerStyle

- (instancetype)init {
    if (self = [super init]) {
        _assetColumn = 3;
    }
    return self;
}

- (VMIPThemeColors *)themeColors {
    if (!_themeColors) {
        UIColor *color = RGB_HEX_COLOR(0x00C7BE);
        _themeColors = @{
            @(UIUserInterfaceStyleUnspecified): color,
            @(UIUserInterfaceStyleLight): color,
            @(UIUserInterfaceStyleDark): color,
        };
    }
    return _themeColors;
}

- (VMIPThemeColors *)navigationBarBkgColors {
    if (!_navigationBarBkgColors) {
        _navigationBarBkgColors = @{
            @(UIUserInterfaceStyleUnspecified): UIColor.clearColor,
            @(UIUserInterfaceStyleLight): UIColor.lightGrayColor,
            @(UIUserInterfaceStyleDark): UIColor.darkGrayColor,
        };
    }
    return _navigationBarBkgColors;
}

- (VMIPThemeFonts *)navigationBarTitleFonts {
    if (!_navigationBarTitleFonts) {
        UIFont *font = [UIFont systemFontOfSize:20.0f weight:(UIFontWeightBold)];
        _navigationBarTitleFonts = @{
            @(UIUserInterfaceStyleUnspecified): font,
            @(UIUserInterfaceStyleLight): font,
            @(UIUserInterfaceStyleDark): font,
        };
    }
    return _navigationBarTitleFonts;
}

- (VMIPThemeColors *)navigationBarTitleColors {
    if (!_navigationBarTitleColors) {
        UIColor *color = RGB_HEX_COLOR(0x00C7BE);
        _navigationBarTitleColors = @{
            @(UIUserInterfaceStyleUnspecified): color,
            @(UIUserInterfaceStyleLight): color,
            @(UIUserInterfaceStyleDark): color,
        };
    }
    return _navigationBarTitleColors;
}

- (VMIPControlThemeFonts *)navigationBarButtonTitleFonts {
    if (!_navigationBarButtonTitleFonts) {
        UIFont *font = [UIFont systemFontOfSize:16.0f weight:(UIFontWeightBold)];
        NSMutableDictionary *fonts = NSMutableDictionary.new;
        fonts[@(UIControlStateNormal)] = font;
        fonts[@(UIControlStateHighlighted)] = font;
        fonts[@(UIControlStateDisabled)] = font;
        fonts[@(UIControlStateFocused)] = font;
        fonts[@(UIControlStateSelected)] = font;
        _navigationBarButtonTitleFonts = @{
            @(UIUserInterfaceStyleUnspecified): fonts,
            @(UIUserInterfaceStyleLight): fonts,
            @(UIUserInterfaceStyleDark): fonts,
        };
    }
    return _navigationBarButtonTitleFonts;
}

- (VMIPControlThemeColors *)navigationBarButtonTitleColors {
    if (!_navigationBarButtonTitleColors) {
        UIColor *color = RGB_HEX_COLOR(0x00C7BE);
        NSMutableDictionary *colors = NSMutableDictionary.new;
        colors[@(UIControlStateNormal)] = color;
        colors[@(UIControlStateHighlighted)] = color;
        colors[@(UIControlStateDisabled)] = color;
        colors[@(UIControlStateFocused)] = color;
        colors[@(UIControlStateSelected)] = color;
        _navigationBarButtonTitleColors = @{
            @(UIUserInterfaceStyleUnspecified): colors,
            @(UIUserInterfaceStyleLight): colors,
            @(UIUserInterfaceStyleDark): colors,
        };
    }
    return _navigationBarButtonTitleColors;
}

- (VMIPControlThemeImages *)navigationBarBackButtonImages {
    if (!_navigationBarBackButtonImages) {
        UIImage *image = [self imageNamed:@"chevron.backward"];
        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
            image = [image imageFlippedForRightToLeftLayoutDirection];
        }
        NSMutableDictionary *images = NSMutableDictionary.new;
        images[@(UIControlStateNormal)] = image;
        images[@(UIControlStateHighlighted)] = image;
        images[@(UIControlStateDisabled)] = image;
        images[@(UIControlStateFocused)] = image;
        images[@(UIControlStateSelected)] = image;
        _navigationBarBackButtonImages = @{
            @(UIUserInterfaceStyleUnspecified): images,
            @(UIUserInterfaceStyleLight): images,
            @(UIUserInterfaceStyleDark): images,
        };
    }
    return _navigationBarBackButtonImages;
}

#pragma mark - Private Getter

- (NSBundle *)bundle {
    NSArray *pngs = nil;
    if (!_bundle) {
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        pngs = [bundle pathsForResourcesOfType:@"png" inDirectory:nil];
        NSURL *url = [bundle URLForResource:@"VMImagePicker" withExtension:@"bundle"];
        _bundle = [NSBundle bundleWithURL:url];
        pngs = [_bundle pathsForResourcesOfType:@"png" inDirectory:nil];
    }
    return _bundle;
}

#pragma mark - Private

- (UIImage *)imageNamed:(NSString *)name {
    NSString *imageName = [name stringByAppendingString:@"@2x"];
    NSString *subPath = [NSString stringWithFormat:@"Images.xcassets/%@.imageset", name];
    NSString *imagePath = [self.bundle pathForResource:imageName ofType:@"png" inDirectory:subPath];
    if (!imagePath) {
        imageName = [name stringByAppendingString:@"@3x"];
        imagePath = [self.bundle pathForResource:imageName ofType:@"png" inDirectory:subPath];
    }
    if (!imagePath) {
        imageName = name;
        imagePath = [self.bundle pathForResource:imageName ofType:@"png" inDirectory:subPath];
    }
    if (!imagePath) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark - ImagePicker

- (VMIPThemeColors *)bkgColors {
    if (!_bkgColors) {
        _bkgColors = @{
            @(UIUserInterfaceStyleUnspecified): UIColor.clearColor,
            @(UIUserInterfaceStyleLight): UIColor.whiteColor,
            @(UIUserInterfaceStyleDark): UIColor.blackColor,
        };
    }
    return _bkgColors;
}

- (VMIPThemeColors *)toolBkgColors {
    if (!_toolBkgColors) {
        _toolBkgColors = @{
            @(UIUserInterfaceStyleUnspecified): UIColor.clearColor,
            @(UIUserInterfaceStyleLight): UIColor.lightGrayColor,
            @(UIUserInterfaceStyleDark): UIColor.darkGrayColor,
        };
    }
    return _toolBkgColors;
}

- (VMIPControlThemeColors *)toolButtonTitleFonts {
    if (!_toolButtonTitleFonts) {
        UIFont *font = [UIFont systemFontOfSize:16.0f weight:(UIFontWeightBold)];
        NSMutableDictionary *fonts = NSMutableDictionary.new;
        fonts[@(UIControlStateNormal)] = font;
        fonts[@(UIControlStateHighlighted)] = font;
        fonts[@(UIControlStateDisabled)] = font;
        fonts[@(UIControlStateFocused)] = font;
        fonts[@(UIControlStateSelected)] = font;
        _toolButtonTitleFonts = @{
            @(UIUserInterfaceStyleUnspecified): fonts,
            @(UIUserInterfaceStyleLight): fonts,
            @(UIUserInterfaceStyleDark): fonts,
        };
    }
    return _toolButtonTitleFonts;
}

- (VMIPControlThemeColors *)toolButtonTitleColors {
    if (!_toolButtonTitleColors) {
        UIColor *color = RGB_HEX_COLOR(0x00C7BE);
        NSMutableDictionary *colors = NSMutableDictionary.new;
        colors[@(UIControlStateNormal)] = color;
        colors[@(UIControlStateHighlighted)] = color;
        colors[@(UIControlStateDisabled)] = color;
        colors[@(UIControlStateFocused)] = color;
        colors[@(UIControlStateSelected)] = color;
        NSMutableDictionary *toolButtonTitleColors = NSMutableDictionary.new;
        toolButtonTitleColors[@(UIUserInterfaceStyleUnspecified)] = colors;
        colors = colors.mutableCopy;
        colors[@(UIControlStateDisabled)] = UIColor.darkGrayColor;
        toolButtonTitleColors[@(UIUserInterfaceStyleLight)] = colors;
        colors = colors.mutableCopy;
        colors[@(UIControlStateDisabled)] = UIColor.lightGrayColor;
        toolButtonTitleColors[@(UIUserInterfaceStyleDark)] = colors;
        _toolButtonTitleColors = toolButtonTitleColors.copy;
    }
    return _toolButtonTitleColors;
}

- (VMIPControlThemeTitles *)toolPreviewButtonTitles {
    if (!_toolPreviewButtonTitles) {
        NSString *title = VMIPLocalizedString(@"Preview(%@)", @"");
        NSMutableDictionary *titles = NSMutableDictionary.new;
        titles[@(UIControlStateNormal)] = title;
        titles[@(UIControlStateHighlighted)] = title;
        titles[@(UIControlStateDisabled)] = title;
        titles[@(UIControlStateFocused)] = title;
        titles[@(UIControlStateSelected)] = title;
        _toolPreviewButtonTitles = @{
            @(UIUserInterfaceStyleUnspecified): titles,
            @(UIUserInterfaceStyleLight): titles,
            @(UIUserInterfaceStyleDark): titles,
        };
    }
    return _toolPreviewButtonTitles;
}

- (VMIPControlThemeTitles *)toolEditButtonTitles {
    if (!_toolEditButtonTitles) {
        NSString *title = VMIPLocalizedString(@"Edit", @"");
        NSMutableDictionary *titles = NSMutableDictionary.new;
        titles[@(UIControlStateNormal)] = title;
        titles[@(UIControlStateHighlighted)] = title;
        titles[@(UIControlStateDisabled)] = title;
        titles[@(UIControlStateFocused)] = title;
        titles[@(UIControlStateSelected)] = title;
        _toolEditButtonTitles = @{
            @(UIUserInterfaceStyleUnspecified): titles,
            @(UIUserInterfaceStyleLight): titles,
            @(UIUserInterfaceStyleDark): titles,
        };
    }
    return _toolEditButtonTitles;
}

- (VMIPControlThemeTitles *)toolOriginalButtonTitles {
    if (!_toolOriginalButtonTitles) {
        NSString *title = VMIPLocalizedString(@"Original", @"");
        NSMutableDictionary *titles = NSMutableDictionary.new;
        titles[@(UIControlStateNormal)] = title;
        titles[@(UIControlStateHighlighted)] = title;
        titles[@(UIControlStateDisabled)] = title;
        titles[@(UIControlStateFocused)] = title;
        titles[@(UIControlStateSelected)] = title;
        _toolOriginalButtonTitles = @{
            @(UIUserInterfaceStyleUnspecified): titles,
            @(UIUserInterfaceStyleLight): titles,
            @(UIUserInterfaceStyleDark): titles,
        };
    }
    return _toolOriginalButtonTitles;
}

- (VMIPControlThemeImages *)toolOriginalButtonImages {
    if (!_toolOriginalButtonImages) {
        UIImage *imageNormal = [self imageNamed:@"circle.theme"];
        UIImage *imageSelected = [self imageNamed:@"circle.inset.filled"];
        NSMutableDictionary *images = NSMutableDictionary.new;
        images[@(UIControlStateNormal)] = imageNormal;
        images[@(UIControlStateHighlighted)] = imageNormal;
        images[@(UIControlStateDisabled)] = imageNormal;
        images[@(UIControlStateFocused)] = imageNormal;
        images[@(UIControlStateSelected)] = imageSelected;
        _toolOriginalButtonImages = @{
            @(UIUserInterfaceStyleUnspecified): images,
            @(UIUserInterfaceStyleLight): images,
            @(UIUserInterfaceStyleDark): images,
        };
    }
    return _toolOriginalButtonImages;
}

- (VMIPControlThemeTitles *)toolDoneButtonTitles {
    if (!_toolDoneButtonTitles) {
        NSString *title = VMIPLocalizedString(@"Done", @"");
        NSMutableDictionary *titles = NSMutableDictionary.new;
        titles[@(UIControlStateNormal)] = title;
        titles[@(UIControlStateHighlighted)] = title;
        titles[@(UIControlStateDisabled)] = title;
        titles[@(UIControlStateFocused)] = title;
        titles[@(UIControlStateSelected)] = title;
        _toolDoneButtonTitles = @{
            @(UIUserInterfaceStyleUnspecified): titles,
            @(UIUserInterfaceStyleLight): titles,
            @(UIUserInterfaceStyleDark): titles,
        };
    }
    return _toolDoneButtonTitles;
}

#pragma mark - Album

- (NSString *)albumTitle {
    if (!_albumTitle) {
        _albumTitle = VMIPLocalizedString(@"Album", @"");
    }
    return _albumTitle;
}

- (CGFloat)albumCellHeight {
    if (_albumCellHeight == 0.0f) {
        _albumCellHeight = 40.0f;
    }
    return _albumCellHeight;
}

- (VMIPCellThemeColors *)albumCellBkgColors {
    if (!_albumCellBkgColors) {
        _albumCellBkgColors = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): UIColor.whiteColor,
                @(YES): UIColor.grayColor,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): UIColor.blackColor,
                @(YES): UIColor.grayColor,
            },
        };
    }
    return _albumCellBkgColors;
}

- (VMIPCellThemeColors *)albumCellNameColors  {
    if (!_albumCellNameColors) {
        _albumCellNameColors = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): UIColor.blackColor,
                @(YES): UIColor.blackColor,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): UIColor.whiteColor,
                @(YES): UIColor.whiteColor,
            },
        };
    }
    return _albumCellNameColors;
}

- (VMIPCellThemeColors *)albumCellNameFonts {
    if (!_albumCellNameFonts) {
        UIFont *font = [UIFont systemFontOfSize:18.0f];
        _albumCellNameFonts = @{
            @(NO): font,
            @(YES): font,
        };
    }
    return _albumCellNameFonts;
}

#pragma mark - Asset

- (VMIPCellThemeImages *)assetSelectedImages {
    if (!_assetSelectedImages) {
        UIImage *normalImage = [self imageNamed:@"circle"];
        UIImage *selectedImage = [self imageNamed:@"circle.fill"];
        _assetSelectedImages = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): normalImage,
                @(YES): selectedImage,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): normalImage,
                @(YES): selectedImage,
            },
        };
    }
    return _assetSelectedImages;
}

- (VMIPCellThemeColors *)assetSelectedTitleColors {
    if (!_assetSelectedTitleColors) {
        UIColor *color = RGB_HEX_COLOR(0xFFFFFF);
        _assetSelectedTitleColors = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): UIColor.clearColor,
                @(YES): color,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): UIColor.clearColor,
                @(YES): color,
            },
        };
    }
    return _assetSelectedTitleColors;
}

- (VMIPCellThemeFonts *)assetSelectedTitleFonts {
    if (!_assetSelectedTitleFonts) {
        UIFont *font = [UIFont systemFontOfSize:14.0f weight:(UIFontWeightMedium)];
        _assetSelectedTitleFonts = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): font,
                @(YES): font,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): font,
                @(YES): font,
            },
        };
    }
    return _assetSelectedTitleFonts;
}

#pragma mark - VideoEdit

- (VMIPCellThemeImages *)videoEditPlayImages {
    if (!_videoEditPlayImages) {
        UIImage *normalImage = [self imageNamed:@"play.circle"];
        _videoEditPlayImages = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): normalImage,
                @(YES): normalImage,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): normalImage,
                @(YES): normalImage,
            },
        };
    }
    return _videoEditPlayImages;
}

- (VMIPCellThemeImages *)videoEditPauseImages {
    if (!_videoEditPauseImages) {
        UIImage *normalImage = [self imageNamed:@""];
        _videoEditPauseImages = @{
            @(UIUserInterfaceStyleLight): @{
                @(NO): normalImage,
                @(YES): normalImage,
            },
            @(UIUserInterfaceStyleDark): @{
                @(NO): normalImage,
                @(YES): normalImage,
            },
        };
    }
    return _videoEditPauseImages;
}

#pragma mark - Public

- (UIColor *)colorWithThemeColors:(VMIPThemeColors *)themeColors {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        UIColor *color = themeColors[@(traitCollection.userInterfaceStyle)];
        if (!color) {
            color = UIColor.clearColor;
        }
        return color;
    }];
}

- (UIFont *)fontWithThemeFonts:(VMIPThemeFonts *)themeFonts {
    return themeFonts[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)];
}

- (UIFont *)fontWithControlThemeFonts:(VMIPControlThemeFonts *)themeFonts state:(UIControlState)state {
    return themeFonts[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)][@(state)];
}

- (NSString *)titleWithControlThemeTitles:(VMIPControlThemeTitles *)themeTitles state:(UIControlState)state {
    return themeTitles[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)][@(state)];
}

- (UIColor *)colorWithControlThemeColors:(VMIPControlThemeColors *)themeColors state:(UIControlState)state {
    return themeColors[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)][@(state)];
}

- (UIImage *)imageWithControlThemeImages:(VMIPControlThemeImages *)themeImages state:(UIControlState)state {
    return themeImages[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)][@(state)];
}

- (UIColor *)colorWithCellThemeColors:(VMIPCellThemeColors *)themeColors selected:(BOOL)selected {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        UIColor *color = themeColors[@(traitCollection.userInterfaceStyle)][@(selected)];
        if (!color) {
            color = UIColor.clearColor;
        }
        return color;
    }];
}

- (UIImage *)imageWithCellThemeImages:(VMIPCellThemeImages *)themeImages selected:(BOOL)selected {
    return themeImages[@(UITraitCollection.currentTraitCollection.userInterfaceStyle)][@(selected)];
}

- (UIFont *)fontWithCellFonts:(VMIPCellFonts *)themeFonts selected:(BOOL)selected {
    UIFont *font = themeFonts[@(selected)];
    if (!font) {
        font = [UIFont systemFontOfSize:11.0f];
    }
    return font;
}

#pragma mark - Button

- (void)styleButton:(UIButton *)button titles:(VMIPControlThemeTitles *)titles {
    [button setTitle:[self titleWithControlThemeTitles:titles state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [button setTitle:[self titleWithControlThemeTitles:titles state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [button setTitle:[self titleWithControlThemeTitles:titles state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [button setTitle:[self titleWithControlThemeTitles:titles state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    [button setTitle:[self titleWithControlThemeTitles:titles state:(UIControlStateSelected)] forState:(UIControlStateSelected)];
}

- (void)styleButton:(UIButton *)button titleColors:(VMIPControlThemeColors *)titleColors {
    [button setTitleColor:[self colorWithControlThemeColors:titleColors state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [button setTitleColor:[self colorWithControlThemeColors:titleColors state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [button setTitleColor:[self colorWithControlThemeColors:titleColors state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [button setTitleColor:[self colorWithControlThemeColors:titleColors state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    [button setTitleColor:[self colorWithControlThemeColors:titleColors state:(UIControlStateSelected)] forState:(UIControlStateSelected)];
}

- (void)styleButton:(UIButton *)button images:(VMIPControlThemeImages *)images {
    [button setImage:[self imageWithControlThemeImages:images state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [button setImage:[self imageWithControlThemeImages:images state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [button setImage:[self imageWithControlThemeImages:images state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [button setImage:[self imageWithControlThemeImages:images state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    [button setImage:[self imageWithControlThemeImages:images state:(UIControlStateSelected)] forState:(UIControlStateSelected)];
}

- (void)styleButton:(UIButton *)button bkgImages:(VMIPControlThemeImages *)bkgImages {
    [button setBackgroundImage:[self imageWithControlThemeImages:bkgImages state:(UIControlStateNormal)] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[self imageWithControlThemeImages:bkgImages state:(UIControlStateHighlighted)] forState:(UIControlStateHighlighted)];
    [button setBackgroundImage:[self imageWithControlThemeImages:bkgImages state:(UIControlStateDisabled)] forState:(UIControlStateDisabled)];
    [button setBackgroundImage:[self imageWithControlThemeImages:bkgImages state:(UIControlStateFocused)] forState:(UIControlStateFocused)];
    [button setBackgroundImage:[self imageWithControlThemeImages:bkgImages state:(UIControlStateSelected)] forState:(UIControlStateSelected)];
}

- (void)styleButton:(UIButton *)button fonts:(VMIPControlThemeFonts *)fonts {
    @weakify(button);
    [[RACObserve(button, state) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(button);
        button.titleLabel.font = [self fontWithControlThemeFonts:fonts state:([x unsignedIntegerValue])];
    }];
}

@end
