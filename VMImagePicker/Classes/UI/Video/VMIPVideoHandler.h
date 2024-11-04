//
//  VMIPVideoHandler.h
//  VMImagePicker
//
//  Created by ItghostFan on 2024/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VMIPVideoPlayer;
@class VMImagePickerStyle;

@interface VMIPVideoHandler : UIViewController

- (instancetype)initWithVideoPlayer:(VMIPVideoPlayer *)videoPlayer
                              style:(VMImagePickerStyle *)style;

@end

NS_ASSUME_NONNULL_END
