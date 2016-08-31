/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Shorthand for returning an icon resource from RMXOverlayResources's singleton. */
#define RMXResources(sel) [RMXOverlayResources iconWithName:sel]

/** Icon resources. */
OBJC_EXTERN NSString *const RMXIconCheck;
OBJC_EXTERN NSString *const RMXIconClose;
OBJC_EXTERN NSString *const RMXIconDropDown;
OBJC_EXTERN NSString *const RMXIconLaunch;
OBJC_EXTERN NSString *const RMXIconRestore;
OBJC_EXTERN NSString *const RMXIconWifi;

/** Icon resources that are used for the overlay controller. */
@interface RMXOverlayResources : NSObject

/**
 Returns an icon image.

 @param name The name of icon to return.
 */
+ (UIImage *)iconWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
