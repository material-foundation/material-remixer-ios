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

#import <Foundation/Foundation.h>

#import "RMXModel.h"

NS_ASSUME_NONNULL_BEGIN

/** The RMXColorPicker class provides a model supporting a color picker control. */
@interface RMXColorPicker : NSObject <RMXModelItemList>

/** Unavailable initializer. Use class initializer instead. */
- (instancetype)init NS_UNAVAILABLE;

/**
 Designated initializer.

 @param title The title to be displayed in the cell for this control.
 @param itemList An array of colors available to the control.
 */
+ (instancetype)controlWithTitle:(NSString *)title itemList:(NSArray<UIColor *> *)itemList;

@end

NS_ASSUME_NONNULL_END
