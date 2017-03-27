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

#import "RMXNumberVariable.h"

#import "RMXRemixer+Private.h"

@implementation RMXNumberVariable

@dynamic limitedToValues;

+ (instancetype)numberVariableWithKey:(NSString *)key
                         defaultValue:(CGFloat)defaultValue
                      limitedToValues:(NSArray<NSNumber *> *)limitedToValues
                          updateBlock:(nullable RMXNumberUpdateBlock)updateBlock {
  RMXVariable *existingVariable = [RMXRemixer variableForKey:key];
  if (existingVariable) {
    [existingVariable addAndExecuteUpdateBlock:^(RMXVariable *variable, id selectedValue) {
      if (updateBlock) {
        updateBlock((RMXNumberVariable *)variable, [selectedValue floatValue]);
      }
    }];
    return (RMXNumberVariable *)existingVariable;
  } else {
    RMXNumberVariable *variable = [[self alloc] initWithKey:key
                                               defaultValue:defaultValue
                                            limitedToValues:limitedToValues
                                                updateBlock:updateBlock];
    [RMXRemixer addVariable:variable];
    return variable;
  }
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = @(self.selectedFloatValue);
  if (self.limitedToValues.count > 0) {
    json[RMXDictionaryKeyLimitedToValues] = self.limitedToValues;
  }
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(CGFloat)defaultValue
            limitedToValues:(NSArray<NSNumber *> *)limitedToValues
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
    self.limitedToValues = limitedToValues;
    self.controlType = limitedToValues.count > 0 ? RMXControlTypeTextList : RMXControlTypeTextInput;
  }
  return self;
}

- (CGFloat)selectedFloatValue {
  return [self.selectedValue floatValue];
}

- (void)setSelectedFloatValue:(CGFloat)selectedFloatValue {
  self.selectedValue = @(selectedFloatValue);
}

@end
