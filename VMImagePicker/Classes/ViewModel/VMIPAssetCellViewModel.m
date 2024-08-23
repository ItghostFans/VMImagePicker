//
//  VMIPAssetCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCellViewModel.h"
#if __has_include("VMIPAssetTableViewModelCell.h")
#import "VMIPAssetTableViewModelCell.h"
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")
#if __has_include("VMIPAssetCollectionViewModelCell.h")
#import "VMIPAssetCollectionViewModelCell.h"
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")

#import <ReactiveObjC/ReactiveObjC.h>

#import "PHImageManager+ImagePicker.h"

@interface VMIPAssetCellViewModel ()

#if __has_include("VMIPAssetTableViewModelCell.h")
@property (strong, nonatomic) VMIPAssetTableViewModelCell *tableCellViewModel;
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")

#if __has_include("VMIPAssetCollectionViewModelCell.h")
@property (strong, nonatomic) VMIPAssetCollectionViewModelCell *collectionCellViewModel;
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *previewImage;
@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation VMIPAssetCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPAssetTableViewModelCell.h")
        _tableCellViewModel = VMIPAssetTableViewModelCell.new;
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")
        
#if __has_include("VMIPAssetCollectionViewModelCell.h")
        _collectionCellViewModel = VMIPAssetCollectionViewModelCell.new;
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")
    }
    return self;
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [self init]) {
        _asset = asset;
        [self loadPreview];
    }
    return self;
}

#pragma mark - Private

- (void)loadPreview {
    @weakify(self);
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat line = MIN(size.width, size.height);
    _requestId = [PHImageManager.defaultManager requestImageOfAsset:_asset size:CGSizeMake(line / 2, line / 2) contentMode:(PHImageContentModeAspectFill) completion:^(BOOL finished, BOOL inCloud, UIImage * _Nullable result, NSDictionary * _Nullable info) {
        @strongify(self);
        NSAssert(NSThread.isMainThread, @"Not in main thread!");
        self.previewImage = result;
    }];
}

#pragma mark - TableView

#if __has_include("VMIPAssetTableViewModelCell.h")
- (Class)tableCellClass {
    return VMIPAssetTableViewModelCell.class;
}
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")

#pragma mark - CollectionView

#if __has_include("VMIPAssetCollectionViewModelCell.h")
- (Class)collectionCellClass {
    return VMIPAssetCollectionViewModelCell.class;
}
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPAssetTableViewModelCell.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAssetTableViewModelCell instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")
    
#if __has_include("VMIPAssetCollectionViewModelCell.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAssetCollectionViewModelCell instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPAssetTableViewModelCell.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAssetTableViewModelCell.h")
    
#if __has_include("VMIPAssetCollectionViewModelCell.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAssetCollectionViewModelCell.h")
}

@end
