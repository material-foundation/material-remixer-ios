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
                          updateBlock:(RMXNumberUpdateBlock)updateBlock {
  RMXNumberVariable *variable = [[self alloc] initWithKey:key
                                             defaultValue:defaultValue
                                              updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

+ (instancetype)numberVariableWithKey:(NSString *)key
                          updateBlock:(RMXNumberUpdateBlock)updateBlock {
  RMXNumberVariable *variable = [[self alloc] initWithKey:key
                                             defaultValue:1
                                              updateBlock:updateBlock];
  return [RMXRemixer addVariable:variable];
}

+ (instancetype)variableFromDictionary:(NSDictionary *)dictionary {
  NSString *key = [dictionary objectForKey:RMXDictionaryKeyKey];
  CGFloat selectedValue = [[dictionary objectForKey:RMXDictionaryKeySelectedValue] floatValue];
  return [[self alloc] initWithKey:key
                      defaultValue:selectedValue
                       updateBlock:nil];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = @(self.selectedFloatValue);
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(CGFloat)defaultValue
                updateBlock:(RMXNumberUpdateBlock)updateBlock {
  self = [super initWithKey:key
             typeIdentifier:RMXTypeNumber
               defaultValue:@(defaultValue)
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  updateBlock(variable, [selectedValue floatValue]);
                }];
  if (self) {
    self.controlType = RMXControlTypeStepper;
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
