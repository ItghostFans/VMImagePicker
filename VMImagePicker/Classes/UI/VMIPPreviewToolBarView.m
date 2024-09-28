//
//  VMIPPreviewToolBarView.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/8.
//

#import "VMIPPreviewToolBarView.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>

@interface VMIPPreviewToolBarView ()
@property (weak, nonatomic) UIButton *editButton;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *doneButton;
@end

@implementation VMIPPreviewToolBarView

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

- (UIButton *)editButton {
    if (_editButton) {
        return _editButton;
    }
    UIButton *editButton = UIButton.new;
    _editButton = editButton;
    [self.style styleButton:_editButton titles:self.style.toolEditButtonTitles];
    [self.style styleButton:_editButton titleColors:self.style.toolButtonTitleColors];
    [self.style styleButton:_editButton fonts:self.style.toolButtonTitleFonts];
    [self addSubview:_editButton];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self);
    }];
    return editButton;
}

- (UIButton *)originalButton {
    if (_originalButton) {
        return _originalButton;
    }
    UIButton *originalButton = UIButton.new;
    _originalButton = originalButton;
    _originalButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 3.0f, 0.0f, 0.0f);
    _originalButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -6.0f, 0.0f, 0.0f);
    [self.style styleButton:_originalButton titles:self.style.toolOriginalButtonTitles];
    [self.style styleButton:_originalButton titleColors:self.style.toolButtonTitleColors];
    [self.style styleButton:_originalButton fonts:self.style.toolButtonTitleFonts];
    [self.style styleButton:_originalButton images:self.style.toolOriginalButtonImages];
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
