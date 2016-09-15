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

#import "RMXBooleanRemix.h"

#import "RMXRemixer.h"

@implementation RMXBooleanRemix

+ (instancetype)addBooleanRemixWithKey:(NSString *)key
                          defaultValue:(BOOL)defaultValue
                           updateBlock:(RMXBooleanUpdateBlock)updateBlock {
  RMXBooleanRemix *remix =
      [[self alloc] initWithKey:key defaultValue:defaultValue updateBlock:updateBlock];
  [RMXRemixer addRemix:remix];
  return remix;
}

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(BOOL)defaultValue
                updateBlock:(RMXBooleanUpdateBlock)updateBlock {
  self = [super initWithKey:key
             typeIdentifier:RMXTypeBoolean
               defaultValue:@(defaultValue)
                updateBlock:^(RMXRemix *_Nonnull remix, id _Nonnull selectedValue) {
                  updateBlock(remix, [selectedValue boolValue]);
                }];
  self.controlType = RMXControlTypeSwitch;
  return self;
}

@end
