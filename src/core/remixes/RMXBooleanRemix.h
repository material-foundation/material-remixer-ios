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

#import "RMXRemix.h"

/** RMXBooleanUpdateBlock is a block that will be invoked when a boolean remix is updated. */
typedef void (^RMXBooleanUpdateBlock)(RMXRemix *remix, BOOL selectedValue);

/** A type of Remix for boolean values. */
@interface RMXBooleanRemix : RMXRemix

/** The selected value of a boolean remix. */
@property(nonatomic, readonly) BOOL selectedValue;

/** Designated initializer */
+ (instancetype)addBooleanRemixWithKey:(NSString *)key
                          defaultValue:(BOOL)defaultValue
                           updateBlock:(RMXBooleanUpdateBlock)updateBlock;

- (void)setSelectedValue:(BOOL)selectedValue fromOverlay:(BOOL)fromOverlay;

@end
