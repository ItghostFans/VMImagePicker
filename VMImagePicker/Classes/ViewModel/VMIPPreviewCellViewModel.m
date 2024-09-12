//
//  VMIPPreviewCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/12.
//

#import "VMIPPreviewCellViewModel.h"
#if __has_include("VMIPPreviewTableCellViewModel.h")
#import "VMIPPreviewTableCellViewModel.h"
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")
#if __has_include("VMIPPreviewCollectionCellViewModel.h")
#import "VMIPPreviewCollectionCellViewModel.h"
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")

@interface VMIPPreviewCellViewModel ()

#if __has_include("VMIPPreviewTableCellViewModel.h")
@property (strong, nonatomic) VMIPPreviewTableCellViewModel *tableCellViewModel;
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")

#if __has_include("VMIPPreviewCollectionCellViewModel.h")
@property (strong, nonatomic) VMIPPreviewCollectionCellViewModel *collectionCellViewModel;
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")

@end

@implementation VMIPPreviewCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPPreviewTableCellViewModel.h")
        _tableCellViewModel = VMIPPreviewTableCellViewModel.new;
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")
        
#if __has_include("VMIPPreviewCollectionCellViewModel.h")
        _collectionCellViewModel = VMIPPreviewCollectionCellViewModel.new;
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")
    }
    return self;
}

#pragma mark - TableView

#if __has_include("VMIPPreviewTableCellViewModel.h")
- (Class)tableCellClass {
    return VMIPPreviewTableCellViewModel.class;
}
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")

#pragma mark - CollectionView

#if __has_include("VMIPPreviewCollectionCellViewModel.h")
- (Class)collectionCellClass {
    return VMIPPreviewCollectionCellViewModel.class;
}
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPPreviewTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPPreviewTableCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")
    
#if __has_include("VMIPPreviewCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPPreviewCollectionCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPPreviewTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPPreviewTableCellViewModel.h")
    
#if __has_include("VMIPPreviewCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPPreviewCollectionCellViewModel.h")
}

@end
