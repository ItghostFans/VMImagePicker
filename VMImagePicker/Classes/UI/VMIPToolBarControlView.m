//
//  VMIPToolBarControlView.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import "VMIPToolBarControlView.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>

@interface VMIPToolBarControlView ()
@property (weak, nonatomic) UIButton *previewButton;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *doneButton;
@end

@implementation VMIPToolBarControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.superview);
        }];
    }
}

#pragma mark - Getter

- (UIButton *)previewButton {
    if (_previewButton) {
        return _previewButton;
    }
    UIButton *previewButton = UIButton.new;
    _previewButton = previewButton;
//    [self.style styleButton:_previewButton titles:self.style.toolPreviewButtonTitles];
//    [self.style styleButton:_previewButton titleColors:self.style.toolButtonTitleColors];
//    [self.style styleButton:_previewButton fonts:self.style.toolButtonTitleFonts];
    [self addSubview:_previewButton];
    [_previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self);
    }];
    return previewButton;
}

- (UIButton *)originalButton {
    if (_originalButton) {
        return _originalButton;
    }
    UIButton *originalButton = UIButton.new;
    _originalButton = originalButton;
//    [self.style styleButton:_originalButton titles:self.style.toolOriginalButtonTitles];
//    [self.style styleButton:_originalButton titleColors:self.style.toolButtonTitleColors];
//    [self.style styleButton:_originalButton fonts:self.style.toolButtonTitleFonts];
    [self addSubview:_originalButton];
    [_originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    return originalButton;
}

- (UIButton *)doneButton {
    if (_doneButton) {
        return _doneButton;
    }
    UIButton *doneButton = UIButton.new;
    _doneButton = doneButton;
//    [self.style styleButton:_doneButton titles:self.style.toolDoneButtonTitles];
//    [self.style styleButton:_doneButton titleColors:self.style.toolButtonTitleColors];
//    [self.style styleButton:_doneButton fonts:self.style.toolButtonTitleFonts];
    [self addSubview:_doneButton];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.equalTo(self);
    }];
    return doneButton;
}

@end
