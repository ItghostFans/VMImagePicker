//
//  VMIPEditVideoTimeIndicatorView.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/26.
//

#import "VMIPEditVideoTimeIndicatorView.h"

@implementation VMIPEditVideoTimeIndicatorView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 检查点是否在扩展的响应区域内
    CGRect hitFrame = CGRectMake(-_hitTestInset.left, -_hitTestInset.top, CGRectGetWidth(self.bounds) + _hitTestInset.left + _hitTestInset.right, CGRectGetHeight(self.bounds) + _hitTestInset.top + _hitTestInset.bottom);
    if (CGRectContainsPoint(hitFrame, point)) {
        return self;
    }
    
    // 如果不在扩展区域内,则调用父类方法
    return [super hitTest:point withEvent:event];
}

@end
