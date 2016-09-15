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

#import "RMXRemix.h"

#import "RMXRemixer.h"

@interface RMXRemix ()
@property(nonatomic, strong) NSMutableArray *updateBlocks;
@end

@implementation RMXRemix

- (instancetype)initWithKey:(NSString *)key
             typeIdentifier:(NSString *)typeIdentifier
               defaultValue:(nullable id)defaultValue
                updateBlock:(RMXUpdateBlock)updateBlock {
  self = [super init];
  if (self) {
    _key = key;
    _typeIdentifier = typeIdentifier;
    _selectedValue = defaultValue;
    _updateBlocks = [NSMutableSet setWithObject:updateBlock];
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

- (void)setSelectedValue:(id)selectedValue fromOverlay:(BOOL)fromOverlay {
  _selectedValue = selectedValue;
  [self executeUpdateBlocks];
  if (fromOverlay) {
    [self.delegate remix:self wasUpdatedFromOverlayToValue:selectedValue];
  }
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
  json[@"key"] = self.typeIdentifier;
  json[@"value"] = self.selectedValue;
  json[@"remixType"] = self.typeIdentifier;
  json[@"controlType"] = @(self.controlType);
  json[@"title"] = self.title;
  return json;
}

@end
