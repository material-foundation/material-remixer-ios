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

#import "RMXRangeVariable.h"

#import "RMXRemixer+Private.h"

@implementation RMXRangeVariable

+ (instancetype)rangeVariableWithKey:(NSString *)key
                        defaultValue:(CGFloat)defaultValue
                            minValue:(CGFloat)minValue
                            maxValue:(CGFloat)maxValue
                           increment:(CGFloat)increment
                         updateBlock:(nullable RMXNumberUpdateBlock)updateBlock {
  RMXVariable *existingVariable = [RMXRemixer variableForKey:key];
  if (existingVariable) {
    [existingVariable addAndExecuteUpdateBlock:^(RMXVariable *variable, id selectedValue) {
      if (updateBlock) {
        updateBlock((RMXNumberVariable *)variable, [selectedValue floatValue]);
      }
    }];
    return (RMXRangeVariable *)existingVariable;
  } else {
    RMXRangeVariable *variable = [[self alloc] initWithKey:key
                                              defaultValue:defaultValue
                                                  minValue:minValue
                                                  maxValue:maxValue
                                                 increment:increment
                                               updateBlock:updateBlock];
    [RMXRemixer addVariable:variable];
    return variable;
  }
}

- (NSString *)constraintType {
  return RMXConstraintTypeRange;
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = @(self.selectedFloatValue);
  json[RMXDictionaryKeyMinValue] = @(self.minimumValue);
  json[RMXDictionaryKeyMaxValue] = @(self.maximumValue);
  json[RMXDictionaryKeyIncrement] = @(self.increment);
  return json;
}

- (void)setLimitedToValues:(NSArray<NSNumber *> *)limitedToValues {
  NSAssert(limitedToValues.count == 0, @"RMXRangeVariable doesn't support setting limitedToValues");
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(CGFloat)defaultValue
                   minValue:(CGFloat)minValue
                   maxValue:(CGFloat)maxValue
                  increment:(CGFloat)increment
                updateBlock:(nullable RMXNumberUpdateBlock)updateBlock {
  self = [super initWithKey:key
                   dataType:RMXDataTypeNumber
               defaultValue:@(defaultValue)
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  if (updateBlock) {
                    updateBlock((RMXNumberVariable *)variable, [selectedValue floatValue]);
                  }
                }];
  if (self) {
    _minimumValue = minValue;
    _maximumValue = maxValue;
    _increment = increment;
    self.controlType = increment > 0 ? RMXControlTypeStepper : RMXControlTypeSlider;
  }
  return self;
}

@end
