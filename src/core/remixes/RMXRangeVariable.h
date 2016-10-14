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

#import "RMXVariable.h"

#import "RMXNumberVariable.h"

@class RMXRangeVariable;

NS_ASSUME_NONNULL_BEGIN

/** A type of Variable for numeric values. */
@interface RMXRangeVariable : RMXNumberVariable

/** The minimum value of the selected value. */
@property(nonatomic, assign) CGFloat minimumValue;

/** The maximum value of the selected value. */
@property(nonatomic, assign) CGFloat maximumValue;

/** The delta used to increment or decrement the value. Optional, defaults to zero. */
@property(nonatomic, assign) CGFloat increment;

/** Initializer for Variables that are stored in the cloud. */
+ (instancetype)rangeVariableWithKey:(NSString *)key updateBlock:(RMXNumberUpdateBlock)updateBlock;

/**
 * Initializer for Variables that are not defined in the cloud. If you're using the cloud mode
 * these properties will be overriden if they differ from what's stored there.
 */
+ (instancetype)rangeVariableWithKey:(NSString *)key
                        defaultValue:(CGFloat)defaultValue
                            minValue:(CGFloat)minValue
                            maxValue:(CGFloat)maxValue
                           increment:(CGFloat)increment
                         updateBlock:(RMXNumberUpdateBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
