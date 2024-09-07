//
//  VMImagePickerStyle.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define VMIPLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
        [bundle localizedStringForKey:(key) value:(val) table:(tbl)]
#define VMIPLocalizedString(key, comment) \
        VMIPLocalizedStringWithDefaultValue(key, nil, self.bundle, @"Undefined localized string", comment)
// 通过以下命令生成多语言文件
// find . -name "*.[m,mm]" -print0 | xargs -0 genstrings -s VMIPLocalizedStringWithDefaultValue -s VMIPLocalizedString -o en.lproj -o zh-Hans.lproj

#pragma mark - UIControl
// @{UIControlState: UIFont *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIFont *> VMIPControlFonts;
// @{UIControlState: UIColor *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIColor *> VMIPControlColors;
// @{UIControlState: NSString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSString *> VMIPControlTitles;
// @{UIControlState: NSAttributedString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSAttributedString *> VMIPControlAttributedTitles;
// @{UIControlState: UIImage *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIImage *> VMIPControlImages;
#pragma mark - Cell
// @{BOOL: UIColor *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIColor *> VMIPCellColors;
// @{BOOL: UIFont *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSString *> VMIPCellFonts;
// @{BOOL: NSString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSString *> VMIPCellTitles;
// @{BOOL: UIImage *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIImage *> VMIPCellImages;
// @{BOOL: NSAttributedString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSAttributedString *> VMIPCellAttributedTitles;
#pragma mark - Theme
// @{UIUserInterfaceStyle: UIColor *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIColor *> VMIPThemeColors;
// @{UIUserInterfaceStyle: UIFont *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIFont *> VMIPThemeFonts;
// @{UIUserInterfaceStyle: NSString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSString *> VMIPThemeTitles;
// @{UIUserInterfaceStyle: NSString *}
typedef NSDictionary<__kindof NSNumber *, __kindof NSAttributedString *> VMIPThemeAttributedTitles;
// @{UIUserInterfaceStyle: UIImage *}
typedef NSDictionary<__kindof NSNumber *, __kindof UIImage *> VMIPThemeImages;

typedef NSDictionary<__kindof NSNumber *, __kindof VMIPControlFonts *> VMIPControlThemeFonts;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPControlColors *> VMIPControlThemeColors;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPControlTitles *> VMIPControlThemeTitles;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPControlImages *> VMIPControlThemeImages;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPControlAttributedTitles *> VMIPControlThemeAttributedTitles;

typedef NSDictionary<__kindof NSNumber *, __kindof VMIPCellColors *> VMIPCellThemeColors;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPCellFonts *> VMIPCellThemeFonts;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPCellTitles *> VMIPCellThemeTitles;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPCellImages *> VMIPCellThemeImages;
typedef NSDictionary<__kindof NSNumber *, __kindof VMIPCellAttributedTitles *> VMIPCellThemeAttributedTitles;

@interface VMImagePickerStyle : NSObject

@property (strong, nonatomic) VMIPThemeColors *navigationBarBkgColors;
@property (strong, nonatomic) VMIPThemeFonts *navigationBarTitleFonts;
@property (strong, nonatomic) VMIPThemeColors *navigationBarTitleColors;
@property (strong, nonatomic) VMIPControlThemeFonts *navigationBarButtonTitleFonts;
@property (strong, nonatomic) VMIPControlThemeColors *navigationBarButtonTitleColors;
@property (strong, nonatomic) VMIPControlThemeImages *navigationBarBackButtonImages;
@property (strong, nonatomic) VMIPThemeColors *bkgColors;

#pragma mark - Album
@property (assign, nonatomic) NSString *albumTitle;
@property (assign, nonatomic) CGFloat albumCellHeight;

@property (strong, nonatomic) VMIPCellThemeColors *albumCellBkgColors;
@property (strong, nonatomic) VMIPCellThemeColors *albumCellNameColors;
@property (strong, nonatomic) VMIPCellThemeColors *albumCellNameFonts;

#pragma mark - Asset
@property (assign, nonatomic) NSUInteger assetColumn;
@property (assign, nonatomic) NSUInteger assetRow;
@property (strong, nonatomic) VMIPCellThemeImages *assetSelectedImages;
@property (strong, nonatomic) VMIPCellThemeColors *assetSelectedTitleColors;
@property (strong, nonatomic) VMIPCellThemeFonts *assetSelectedTitleFonts;

- (UIColor *)colorWithThemeColors:(VMIPThemeColors *)themeColors;
- (UIFont *)fontWithThemeFonts:(VMIPThemeFonts *)themeFonts;
- (UIFont *)fontWithControlThemeFonts:(VMIPControlThemeFonts *)themeFonts state:(UIControlState)state;
- (UIColor *)colorWithControlThemeColors:(VMIPControlThemeColors *)themeColors state:(UIControlState)state;
- (UIImage *)imageWithControlThemeImages:(VMIPControlThemeImages *)themeImages state:(UIControlState)state;
- (UIColor *)colorWithCellThemeColors:(VMIPCellThemeColors *)themeColors selected:(BOOL)selected;
- (UIImage *)imageWithCellThemeImages:(VMIPCellThemeImages *)themeImages selected:(BOOL)selected;
- (UIFont *)fontWithCellFonts:(VMIPCellFonts *)themeFonts selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
