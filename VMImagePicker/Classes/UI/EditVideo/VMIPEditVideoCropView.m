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
@property (weak, nonatomic) UIView *beginBarView;
@property (weak, nonatomic) UIView *endBarView;
@property (weak, nonatomic) UIView *topLineView;
@property (weak, nonatomic) UIView *bottomLineView;
@property (assign, nonatomic) CGFloat barWidth;
@property (assign, nonatomic) CGFloat lineHeight;

@property (assign, nonatomic) CGRect originalBounds;
@end

@implementation VMIPEditVideoCropView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _barWidth = 20.0f;
        _lineHeight = 3.0f;
        _originalBounds = CGRectZero;
    }
    return self;
}

- (CGFloat)begin {
    CGFloat width = CGRectGetWidth(self.bounds) - (_barWidth * 2);
    return (CGRectGetMaxX(self.beginBarView.frame) - _barWidth) / width;
}

- (CGFloat)end {
    CGFloat width = CGRectGetWidth(self.bounds) - (_barWidth * 2);
    return (CGRectGetMinX(self.endBarView.frame) - _barWidth) / width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, _originalBounds)) {
        return;
    }
    _originalBounds = self.bounds;
    self.beginBarView.frame = CGRectMake(0.0f, 0.0f, _barWidth, CGRectGetHeight(self.bounds));
    self.endBarView.frame = CGRectMake(CGRectGetWidth(self.bounds) - _barWidth, 0.0f, _barWidth, CGRectGetHeight(self.bounds));
    [self relayoutLines];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

#pragma mark - Private

- (void)relayoutLines {
    CGFloat beginMaxX = CGRectGetMaxX(self.beginBarView.frame);
    CGFloat endMinX = CGRectGetMinX(self.endBarView.frame);
    self.topLineView.frame = CGRectMake(beginMaxX, 0.0f, endMinX - beginMaxX, _lineHeight);
    self.bottomLineView.frame = CGRectMake(beginMaxX, CGRectGetHeight(self.bounds) - _lineHeight, endMinX - beginMaxX, _lineHeight);
}

#pragma mark - Actions

- (void)onBeginPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    CGRect frame = self.beginBarView.frame;
    frame.origin.x += translation.x;
    
    // 限制移动范围
    frame.origin.x = MAX(0, MIN(frame.origin.x, CGRectGetMinX(self.endBarView.frame) - _barWidth));
    
    self.beginBarView.frame = frame;
    [pan setTranslation:CGPointZero inView:self];
    [self relayoutLines];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 可以在这里添加结束拖动时的逻辑，比如回调
    }
}

- (void)onEndPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    CGRect frame = self.endBarView.frame;
    frame.origin.x += translation.x;
    
    // 限制移动范围
    frame.origin.x = MAX(CGRectGetMaxX(self.beginBarView.frame), MIN(frame.origin.x, CGRectGetWidth(self.bounds) - _barWidth));
    
    self.endBarView.frame = frame;
    [pan setTranslation:CGPointZero inView:self];
    [self relayoutLines];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 可以在这里添加结束拖动时的逻辑，比如回调
    }
}

#pragma mark - Getter

- (UIView *)beginBarView {
    if (_beginBarView) {
        return _beginBarView;
    }
    UIView *beginBarView = UIView.new;
    _beginBarView = beginBarView;
    _beginBarView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    _beginBarView.backgroundColor = UIColor.blueColor;
    [self addSubview:_beginBarView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onBeginPan:)];
    [_beginBarView addGestureRecognizer:pan];
    return beginBarView;
}

- (UIView *)endBarView {
    if (_endBarView) {
        return _endBarView;
    }
    UIView *endBarView = UIView.new;
    _endBarView = endBarView;
    _endBarView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    [self addSubview:_endBarView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onEndPan:)];
    [_endBarView addGestureRecognizer:pan];
    return endBarView;
}

- (UIView *)topLineView {
    if (_topLineView) {
        return _topLineView;
    }
    UIView *topLineView = UIView.new;
    _topLineView = topLineView;
    _topLineView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    [self addSubview:_topLineView];
    return topLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView) {
        return _bottomLineView;
    }
    UIView *bottomLineView = UIView.new;
    _bottomLineView = bottomLineView;
    _bottomLineView.backgroundColor = [self.style colorWithThemeColors:self.style.themeColors];
    [self addSubview:_bottomLineView];
    return bottomLineView;
}

@end
