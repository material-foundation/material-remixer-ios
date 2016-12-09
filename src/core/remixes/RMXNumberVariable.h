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

/** Designated initializer. */
+ (instancetype)numberVariableWithKey:(NSString *)key
                         defaultValue:(CGFloat)defaultValue
                       possibleValues:(nullable NSArray<NSNumber *> *)possibleValues
                          updateBlock:(RMXNumberUpdateBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
