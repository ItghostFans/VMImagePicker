//
//  VMIPAlbumCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumCellViewModel.h"
#if __has_include("VMIPAlbumTableViewModelCell.h")
#import "VMIPAlbumTableViewModelCell.h"
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")
#if __has_include("VMIPAlbumCollectionViewModelCell.h")
#import "VMIPAlbumCollectionViewModelCell.h"
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")

@interface VMIPAlbumCellViewModel ()

#if __has_include("VMIPAlbumTableViewModelCell.h")
@property (strong, nonatomic) VMIPAlbumTableViewModelCell *tableCellViewModel;
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")

#if __has_include("VMIPAlbumCollectionViewModelCell.h")
@property (strong, nonatomic) VMIPAlbumCollectionViewModelCell *collectionCellViewModel;
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")

@end

@implementation VMIPAlbumCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPAlbumTableViewModelCell.h")
        _tableCellViewModel = VMIPAlbumTableViewModelCell.new;
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")
        
#if __has_include("VMIPAlbumCollectionViewModelCell.h")
        _collectionCellViewModel = VMIPAlbumCollectionViewModelCell.new;
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")
    }
    return self;
}

#pragma mark - TableView

#if __has_include("VMIPAlbumTableViewModelCell.h")
- (Class)tableCellClass {
    return VMIPAlbumTableViewModelCell.class;
}
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")

#pragma mark - CollectionView

#if __has_include("VMIPAlbumCollectionViewModelCell.h")
- (Class)collectionCellClass {
    return VMIPAlbumCollectionViewModelCell.class;
}
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPAlbumTableViewModelCell.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAlbumTableViewModelCell instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")
    
#if __has_include("VMIPAlbumCollectionViewModelCell.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAlbumCollectionViewModelCell instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPAlbumTableViewModelCell.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAlbumTableViewModelCell.h")
    
#if __has_include("VMIPAlbumCollectionViewModelCell.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAlbumCollectionViewModelCell.h")
}

@end
