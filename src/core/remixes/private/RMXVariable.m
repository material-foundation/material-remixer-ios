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

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "RMXVariable.h"

#import "RMXRemixer.h"

@interface RMXVariable ()
@property(nonatomic, strong) NSMutableArray *updateBlocks;
@end

@implementation RMXVariable

- (instancetype)initWithKey:(NSString *)key
             typeIdentifier:(NSString *)typeIdentifier
               defaultValue:(nullable id)defaultValue
                updateBlock:(nullable RMXUpdateBlock)updateBlock {
  self = [super init];
  if (self) {
    _key = key;
    _typeIdentifier = typeIdentifier;
    _selectedValue = defaultValue;
    if (updateBlock) {
      _updateBlocks = [NSMutableArray arrayWithObject:updateBlock];
    } else {
      _updateBlocks = [NSMutableArray array];
    }
  }
  return self;
}

+ (instancetype)variableFromDictionary:(NSDictionary *)dictionary {
  return [[self alloc] initWithKey:[dictionary objectForKey:RMXDictionaryKeyKey]
                    typeIdentifier:[dictionary objectForKey:RMXDictionaryKeyTypeIdentifier]
                      defaultValue:[dictionary objectForKey:RMXDictionaryKeySelectedValue]
                       updateBlock:nil];
}

- (NSString *)title {
  if (_title.length > 0) {
    return _title;
  } else {
    return _key;
  }
}

- (void)setSelectedValue:(id)selectedValue {
  _selectedValue = selectedValue;
  [self executeUpdateBlocks];
  [[NSNotificationCenter defaultCenter] postNotificationName:RMXVariableUpdateNotification
                                                      object:self];
}

- (void)save {
  [RMXRemixer saveVariable:self];
}

- (void)updateToStoredVariable:(RMXVariable *)storedVariable {
  self.selectedValue = storedVariable.selectedValue;
  self.possibleValues = storedVariable.possibleValues;
  [self executeUpdateBlocks];
}

- (void)executeUpdateBlocks {
  for (RMXUpdateBlock updateBlock in _updateBlocks) {
    updateBlock(self, _selectedValue);
  }
}

- (void)addAndExecuteUpdateBlock:(RMXUpdateBlock)updateBlock {
  [_updateBlocks addObject:updateBlock];
  updateBlock(self, _selectedValue);
}

- (NSMutableDictionary *)toJSON {
  NSMutableDictionary *json = [NSMutableDictionary dictionary];
  json[RMXDictionaryKeyKey] = self.key;
  json[RMXDictionaryKeyTypeIdentifier] = self.typeIdentifier;
  json[RMXDictionaryKeyControlType] = @(self.controlType);
  json[RMXDictionaryKeyTitle] = self.title;
  return json;
}

@end
