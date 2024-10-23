//
//  VMIPEditVideoCropView.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/23.
//

#import "VMIPEditVideoCropView.h"
#import "VMImagePickerStyle.h"

#import <Masonry/Masonry.h>

@interface VMIPEditVideoCropView ()
@property (weak, nonatomic) UIImageView *beginBarView;
@property (weak, nonatomic) UIImageView *endBarView;
@property (assign, nonatomic) CGFloat barWidth;
@end

@implementation VMIPEditVideoCropView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _barWidth = 20.0f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.beginBarView.frame = CGRectMake(0.0f, 0.0f, _barWidth, CGRectGetHeight(self.bounds));
    self.endBarView.frame = CGRectMake(CGRectGetWidth(self.bounds) - _barWidth, 0.0f, _barWidth, CGRectGetHeight(self.bounds));
}

#pragma mark - Getter

- (UIImageView *)beginBarView {
    if (_beginBarView) {
        return _beginBarView;
    }
    UIImageView *beginBarView = UIImageView.new;
    _beginBarView = beginBarView;
    _beginBarView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    [self addSubview:_beginBarView];
    return beginBarView;
}

- (UIImageView *)endBarView {
    if (_endBarView) {
        return _endBarView;
    }
    UIImageView *endBarView = UIImageView.new;
    _endBarView = endBarView;
    _endBarView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    [self addSubview:_endBarView];
    return endBarView;
}

@end
