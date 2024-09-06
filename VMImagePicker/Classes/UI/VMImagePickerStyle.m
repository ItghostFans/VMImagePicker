//
//  VMImagePickerStyle.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import "VMImagePickerStyle.h"

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
        NSMutableDictionary *images = NSMutableDictionary.new;
        images[@(UIControlStateNormal)] = image;
        images[@(UIControlStateHighlighted)] = image;
        images[@(UIControlStateDisabled)] = image;
        images[@(UIControlStateFocused)] = image;
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

#pragma mark - Album

- (NSString *)albumTitle {
    if (!_albumTitle) {
        _albumTitle = VMIPLocalizedString(@"Albums", @"");
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

- (UIFont *)fontWithCellFonts:(VMIPCellFonts *)themeFonts selected:(BOOL)selected {
    UIFont *font = themeFonts[@(selected)];
    if (!font) {
        font = [UIFont systemFontOfSize:11.0f];
    }
    return font;
}

@end
