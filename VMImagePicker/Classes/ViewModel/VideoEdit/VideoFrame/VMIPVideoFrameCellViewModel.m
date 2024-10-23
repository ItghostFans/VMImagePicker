//
//  VMIPVideoFrameCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/10/20.
//

#import "VMIPVideoFrameCellViewModel.h"
#if __has_include("VMIPVideoFrameTableCellViewModel.h")
#import "VMIPVideoFrameTableCellViewModel.h"
#endif // #if __has_include("VMIPVideoFrameTableCellViewModel.h")
#if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
#import "VMIPVideoFrameCollectionCellViewModel.h"
#endif // #if __has_include("VMIPVideoFrameCollectionCellViewModel.h")

@interface VMIPVideoFrameCellViewModel ()

#if __has_include("VMIPVideoFrameTableCellViewModel.h")
@property (strong, nonatomic) VMIPVideoFrameTableCellViewModel *tableCellViewModel;
#endif // #if __has_include("VMIPVideoFrameTableCellViewModel.h")

#if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
@property (strong, nonatomic) VMIPVideoFrameCollectionCellViewModel *collectionCellViewModel;
#endif // #if __has_include("VMIPVideoFrameCollectionCellViewModel.h")

@property (strong, nonatomic) UIImage *frameImage;

@end

@implementation VMIPVideoFrameCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPVideoFrameTableCellViewModel.h")
        _tableCellViewModel = VMIPVideoFrameTableCellViewModel.new;
#endif // #if __has_include("VMIPVideoFrameTableCellViewModel.h")
        
#if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
        _collectionCellViewModel = VMIPVideoFrameCollectionCellViewModel.new;
#endif // #if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
    }
    return self;
}

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPVideoFrameTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPVideoFrameTableCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPVideoFrameTableCellViewModel.h")
    
#if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPVideoFrameCollectionCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPVideoFrameTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPVideoFrameTableCellViewModel.h")
    
#if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPVideoFrameCollectionCellViewModel.h")
}

@end
