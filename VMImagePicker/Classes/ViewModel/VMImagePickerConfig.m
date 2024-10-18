//
//  VMImagePickerConfig.m
//  VMImagePicker
//
//  Created by ItghostFan on 2024/9/28.
//

#import "VMImagePickerConfig.h"

@interface VMImagePickerConfig ()
@end

@implementation VMImagePickerConfig

- (instancetype)init {
    if (self = [super init]) {
        _count = 99;
        _directory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"VMImagePicker"];
    }
    return self;
}

@end
