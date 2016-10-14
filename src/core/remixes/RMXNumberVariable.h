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

#import <CoreGraphics/CoreGraphics.h>

@class RMXNumberVariable;

NS_ASSUME_NONNULL_BEGIN

/** RMXNumberUpdateBlock is a block that will be invoked when a range Variable is updated. */
typedef void (^RMXNumberUpdateBlock)(RMXNumberVariable *variable, CGFloat selectedValue);

/** A type of Variable for numeric values. */
@interface RMXNumberVariable : RMXVariable

/** Convenience accessor for the selectedValue property. */
@property(nonatomic, assign) CGFloat selectedFloatValue;

/** If set, these are the only values this Variable can take. */
@property(nonatomic, strong) NSArray<NSNumber *> *possibleValues;

/** Convenience initializer for Variables that are stored in the cloud. */
+ (instancetype)numberVariableWithKey:(NSString *)key updateBlock:(RMXNumberUpdateBlock)updateBlock;

/**
 * Initializer for Variables that are not defined in the cloud. If you're using the cloud mode
 * these properties will be overriden if they differ from what's stored there.
 */
+ (instancetype)numberVariableWithKey:(NSString *)key
                         defaultValue:(CGFloat)defaultValue
                          updateBlock:(RMXNumberUpdateBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
