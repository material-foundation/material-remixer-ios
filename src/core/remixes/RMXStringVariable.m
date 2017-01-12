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

#import "RMXStringVariable.h"

#import "RMXRemixer.h"

@implementation RMXStringVariable

@dynamic selectedValue;
@dynamic limitedToValues;

+ (instancetype)stringVariableWithKey:(NSString *)key
                         defaultValue:(NSString *)defaultValue
                      limitedToValues:(NSArray<NSString *> *)limitedToValues
                          updateBlock:(RMXStringUpdateBlock)updateBlock {
  RMXStringVariable *variable = [[self alloc] initWithKey:key
                                             defaultValue:defaultValue
                                          limitedToValues:limitedToValues
                                              updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = self.selectedValue;
  if (self.limitedToValues.count > 0) {
    json[RMXDictionaryKeyLimitedToValues] = self.limitedToValues;
  }
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(NSString *)defaultValue
            limitedToValues:(NSArray<NSString *> *)limitedToValues
                updateBlock:(RMXStringUpdateBlock)updateBlock {
  self = [super initWithKey:key
                   dataType:RMXDataTypeString
               defaultValue:defaultValue
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  updateBlock((RMXStringVariable *)variable, selectedValue);
                }];
  self.limitedToValues = limitedToValues;
  self.controlType = limitedToValues.count > 0 ? RMXControlTypeTextList : RMXControlTypeTextInput;
  return self;
}

@end
