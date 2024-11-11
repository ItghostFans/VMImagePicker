//
//  VMIPEditVideoToolBarView.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import "VMIPEditVideoToolBarView.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>

#import <VMLocalization/VMLocalization.h>

@interface VMIPEditVideoToolBarView ()
@property (weak, nonatomic) UIButton *doneButton;
@end

@implementation VMIPEditVideoToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    UINavigationController *navigationController = self;
    do {
        navigationController = navigationController.nextResponder;
    } while (navigationController && ![navigationController isKindOfClass:UINavigationController.class]);
    return navigationController.toolbar.frame.size;
}

#pragma mark - Getter

- (UIButton *)doneButton {
    if (_doneButton) {
        return _doneButton;
    }
    UIButton *doneButton = UIButton.new;
    _doneButton = doneButton;
    [self.style styleButton:_doneButton titles:self.style.toolDoneButtonTitles];
    [self.style styleButton:_doneButton titleColors:self.style.toolButtonTitleColors];
    [self.style styleButton:_doneButton fonts:self.style.toolButtonTitleFonts];
    [self addSubview:_doneButton];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.equalTo(self);
    }];
    return doneButton;
}

@end
