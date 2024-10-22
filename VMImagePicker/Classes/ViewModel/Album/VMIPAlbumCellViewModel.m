//
//  VMIPAlbumCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAlbumCellViewModel.h"
#if __has_include("VMIPAlbumTableCellViewModel.h")
#import "VMIPAlbumTableCellViewModel.h"
#endif // #if __has_include("VMIPAlbumTableCellViewModel.h")
#if __has_include("VMIPAlbumCollectionCellViewModel.h")
#import "VMIPAlbumCollectionCellViewModel.h"
#endif // #if __has_include("VMIPAlbumCollectionCellViewModel.h")

@interface VMIPAlbumCellViewModel ()

#if __has_include("VMIPAlbumTableCellViewModel.h")
@property (strong, nonatomic) VMIPAlbumTableCellViewModel *tableCellViewModel;
#endif // #if __has_include("VMIPAlbumTableCellViewModel.h")

#if __has_include("VMIPAlbumCollectionCellViewModel.h")
@property (strong, nonatomic) VMIPAlbumCollectionCellViewModel *collectionCellViewModel;
#endif // #if __has_include("VMIPAlbumCollectionCellViewModel.h")

@property (strong, nonatomic) PHAssetCollection *assetCollection;

@end

@implementation VMIPAlbumCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPAlbumTableCellViewModel.h")
        _tableCellViewModel = VMIPAlbumTableCellViewModel.new;
#endif // #if __has_include("VMIPAlbumTableCellViewModel.h")
        
#if __has_include("VMIPAlbumCollectionCellViewModel.h")
        _collectionCellViewModel = VMIPAlbumCollectionCellViewModel.new;
#endif // #if __has_include("VMIPAlbumCollectionCellViewModel.h")
    }
    return self;
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
    if (self = [self init]) {
        _assetCollection = assetCollection;
        _name = assetCollection.localizedTitle;
    }
    return self;
}

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPAlbumTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAlbumTableCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAlbumTableCellViewModel.h")
    
#if __has_include("VMIPAlbumCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAlbumCollectionCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAlbumCollectionCellViewModel.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPAlbumTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAlbumTableCellViewModel.h")
    
#if __has_include("VMIPAlbumCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAlbumCollectionCellViewModel.h")
}

@end
