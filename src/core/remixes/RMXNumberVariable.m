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

#import "RMXRemixer.h"

@implementation RMXNumberVariable

@dynamic possibleValues;

+ (instancetype)numberVariableWithKey:(NSString *)key
                         defaultValue:(CGFloat)defaultValue
                       possibleValues:(NSArray<NSNumber *> *)possibleValues
                          updateBlock:(RMXNumberUpdateBlock)updateBlock {
  RMXNumberVariable *variable = [[self alloc] initWithKey:key
                                             defaultValue:defaultValue
                                           possibleValues:possibleValues
                                              updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = @(self.selectedFloatValue);
  if (self.possibleValues.count > 0) {
    json[RMXDictionaryKeyPossibleValues] = self.possibleValues;
  }
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(CGFloat)defaultValue
             possibleValues:(NSArray<NSNumber *> *)possibleValues
                updateBlock:(RMXNumberUpdateBlock)updateBlock {
  self = [super initWithKey:key
                   dataType:RMXDataTypeNumber
               defaultValue:@(defaultValue)
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  updateBlock((RMXNumberVariable *)variable, [selectedValue floatValue]);
                }];
  if (self) {
    self.possibleValues = possibleValues;
    self.controlType = possibleValues.count > 0 ? RMXControlTypeTextList : RMXControlTypeTextInput;
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
