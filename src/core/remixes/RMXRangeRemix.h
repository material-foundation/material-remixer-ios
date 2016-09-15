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

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/** RMXRangeUpdateBlock is a block that will be invoked when a range remix is updated. */
typedef void (^RMXRangeUpdateBlock)(RMXRemix *remix, CGFloat selectedValue);

/** A type of Remix for numeric values. */
@interface RMXRangeRemix : RMXRemix

/** The selected value of a given remix. */
@property(nonatomic, assign) NSNumber *selectedValue;

/** The minimum value available to this control. */
@property(nonatomic, assign) CGFloat minimumValue;

/** The maximum value available to this control. */
@property(nonatomic, assign) CGFloat maximumValue;

/** The delta used to increment or decrement the value. Optional. */
@property(nonatomic, assign) CGFloat increment;

/** Designated initializer */
+ (instancetype)addRangeRemixWithKey:(NSString *)key
                        defaultValue:(CGFloat)defaultValue
                            minValue:(CGFloat)minValue
                            maxValue:(CGFloat)maxValue
                           increment:(CGFloat)increment
                         updateBlock:(RMXRangeUpdateBlock)updateBlock;

/** Convenience initializer */
+ (instancetype)addRangeRemixWithKey:(NSString *)key
                        defaultValue:(CGFloat)defaultValue
                            minValue:(CGFloat)minValue
                            maxValue:(CGFloat)maxValue
                         updateBlock:(RMXRangeUpdateBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
