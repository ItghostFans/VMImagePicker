//
//  VMIPAssetCellViewModel.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/8/21.
//

#import "VMIPAssetCellViewModel.h"
#if __has_include("VMIPAssetTableCellViewModel.h")
#import "VMIPAssetTableCellViewModel.h"
#endif // #if __has_include("VMIPAssetTableCellViewModel.h")
#if __has_include("VMIPAssetCollectionCellViewModel.h")
#import "VMIPAssetCollectionCellViewModel.h"
#endif // #if __has_include("VMIPAssetCollectionCellViewModel.h")

#import <ReactiveObjC/ReactiveObjC.h>

#import "PHImageManager+ImagePicker.h"

@interface VMIPAssetCellViewModel ()

#if __has_include("VMIPAssetTableCellViewModel.h")
@property (strong, nonatomic) VMIPAssetTableCellViewModel *tableCellViewModel;
#endif // #if __has_include("VMIPAssetTableCellViewModel.h")

#if __has_include("VMIPAssetCollectionCellViewModel.h")
@property (strong, nonatomic) VMIPAssetCollectionCellViewModel *collectionCellViewModel;
#endif // #if __has_include("VMIPAssetCollectionCellViewModel.h")

@property (strong, nonatomic) PHAsset *asset;
@property (assign, nonatomic) BOOL inCloud;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) UIImage *previewImage;
@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation VMIPAssetCellViewModel

- (instancetype)init {
    if (self = [super init]) {
#if __has_include("VMIPAssetTableCellViewModel.h")
        _tableCellViewModel = VMIPAssetTableCellViewModel.new;
#endif // #if __has_include("VMIPAssetTableCellViewModel.h")
        
#if __has_include("VMIPAssetCollectionCellViewModel.h")
        _collectionCellViewModel = VMIPAssetCollectionCellViewModel.new;
#endif // #if __has_include("VMIPAssetCollectionCellViewModel.h")
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
    _requestId = [PHImageManager.defaultManager requestImageOfAsset:_asset size:CGSizeMake(line / 2, line / 2) contentMode:(PHImageContentModeAspectFill) completion:^(BOOL finished, BOOL inCloud, BOOL degraded, UIImage * _Nullable result, NSDictionary * _Nullable info) {
        @strongify(self);
        NSAssert(NSThread.isMainThread, @"Not in main thread!");
        if ([info[PHImageResultRequestIDKey] intValue] != self.requestId) {
            return;
        }
        if (!finished) {
            return;
        }
        self.previewImage = result;
        self.inCloud = inCloud;
        if (!degraded) {
            self.requestId = PHInvalidImageRequestID;
        }
    }];
}

#pragma mark - Fowarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;
#if __has_include("VMIPAssetTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAssetTableCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAssetTableCellViewModel.h")
    
#if __has_include("VMIPAssetCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:aSelector]) {
        methodSignature = [VMIPAssetCollectionCellViewModel instanceMethodSignatureForSelector:aSelector];
    }
#endif // #if __has_include("VMIPAssetCollectionCellViewModel.h")
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if __has_include("VMIPAssetTableCellViewModel.h")
    if ([_tableCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_tableCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAssetTableCellViewModel.h")
    
#if __has_include("VMIPAssetCollectionCellViewModel.h")
    if ([_collectionCellViewModel respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_collectionCellViewModel];
        return;
    }
#endif // #if __has_include("VMIPAssetCollectionCellViewModel.h")
}

@end
