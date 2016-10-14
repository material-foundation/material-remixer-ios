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
@dynamic possibleValues;

+ (instancetype)stringVariableWithKey:(NSString *)key
                         defaultValue:(NSString *)defaultValue
                       possibleValues:(NSArray<NSString *> *)possibleValues
                          updateBlock:(RMXStringUpdateBlock)updateBlock {
  RMXStringVariable *variable = [[self alloc] initWithKey:key
                                             defaultValue:defaultValue
                                           possibleValues:possibleValues
                                              updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

+ (instancetype)stringVariableWithKey:(NSString *)key
                          updateBlock:(RMXStringUpdateBlock)updateBlock {
  // These default values are just temporary. We change them to the right values as soon as we
  // get the data from the cloud service.
  RMXStringVariable *variable =
      [[self alloc] initWithKey:key defaultValue:@"" possibleValues:nil updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

+ (instancetype)variableFromDictionary:(NSDictionary *)dictionary {
  return [[self alloc] initWithKey:[dictionary objectForKey:RMXDictionaryKeyKey]
                      defaultValue:[dictionary objectForKey:RMXDictionaryKeySelectedValue]
                    possibleValues:[dictionary objectForKey:RMXDictionaryKeyPossibleValues]
                       updateBlock:nil];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = self.selectedValue;
  if (self.possibleValues.count > 0) {
    json[RMXDictionaryKeyPossibleValues] = self.possibleValues;
  }
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(NSString *)defaultValue
             possibleValues:(NSArray<NSString *> *)possibleValues
                updateBlock:(RMXStringUpdateBlock)updateBlock {
  self = [super initWithKey:key
             typeIdentifier:RMXTypeString
               defaultValue:defaultValue
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  updateBlock(variable, selectedValue);
                }];
  self.possibleValues = possibleValues;
  self.controlType = RMXControlTypeTextPicker;
  return self;
}

@end
