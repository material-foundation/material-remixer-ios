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

#import "RMXBooleanVariable.h"

#import "RMXRemixer.h"

@implementation RMXBooleanVariable

+ (instancetype)booleanVariableWithKey:(NSString *)key
                          defaultValue:(BOOL)defaultValue
                           updateBlock:(nullable RMXBooleanUpdateBlock)updateBlock {
  RMXVariable *existingVariable = [RMXRemixer variableForKey:key];
  if (existingVariable) {
    [existingVariable addAndExecuteUpdateBlock:^(RMXVariable *variable, id selectedValue) {
      if (updateBlock) {
        updateBlock((RMXBooleanVariable *)variable, [selectedValue boolValue]);
      }
    }];
    return existingVariable;
  } else {
    RMXBooleanVariable *variable =
        [[self alloc] initWithKey:key defaultValue:defaultValue updateBlock:updateBlock];
    [RMXRemixer addVariable:variable];
    return variable;
  }
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = @([self selectedBooleanValue]);
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(BOOL)defaultValue
                updateBlock:(RMXBooleanUpdateBlock)updateBlock {
  self = [super initWithKey:key
                   dataType:RMXDataTypeBoolean
               defaultValue:@(defaultValue)
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  if (updateBlock) {
                    updateBlock((RMXBooleanVariable *)variable, [selectedValue boolValue]);
                  }
                }];
  self.controlType = RMXControlTypeSwitch;
  return self;
}

- (BOOL)selectedBooleanValue {
  return [self.selectedValue boolValue];
}

- (void)setSelectedBooleanValue:(BOOL)selectedBooleanValue {
  self.selectedValue = @(selectedBooleanValue);
}

@end
