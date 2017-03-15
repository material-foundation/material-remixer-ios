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
                   dataType:(NSString *)dataType
               defaultValue:(nullable id)defaultValue
                updateBlock:(nullable RMXUpdateBlock)updateBlock {
  self = [super init];
  if (self) {
    _key = [self sanitizeKey:key];
    _dataType = dataType;
    _selectedValue = defaultValue;
    if (updateBlock) {
      _updateBlocks = [NSMutableArray arrayWithObject:updateBlock];
    } else {
      _updateBlocks = [NSMutableArray array];
    }
  }
  return self;
}

- (NSString *)title {
  if (_title.length > 0) {
    return _title;
  } else {
    return _key;
  }
}

- (NSString *)constraintType {
  if (_limitedToValues.count > 0) {
    return RMXConstraintTypeList;
  } else {
    return RMXConstraintTypeNone;
  }
}

- (void)setSelectedValue:(id)selectedValue {
  _selectedValue = selectedValue;
  [self triggerCellUpdateNotification];
  [self executeUpdateBlocks];
}

- (void)setLimitedToValues:(NSArray<id> *)limitedToValues {
  _limitedToValues = limitedToValues;
  [self triggerCellUpdateNotification];
}

- (void)save {
  [RMXRemixer saveVariable:self];
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
  json[RMXDictionaryKeyDataType] = self.dataType;
  json[RMXDictionaryKeyConstraintType] = self.constraintType;
  json[RMXDictionaryKeyControlType] = self.controlType;
  json[RMXDictionaryKeyTitle] = self.title;
  return json;
}

#pragma mark - Private

- (NSString *)sanitizeKey:(NSString *)key {
  return [key stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

- (void)triggerCellUpdateNotification {
  [[NSNotificationCenter defaultCenter] postNotificationName:RMXVariableUpdateNotification
                                                      object:self];
}

@end
