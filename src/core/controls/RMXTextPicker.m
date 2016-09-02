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

#import "RMXTextPicker.h"

@implementation RMXTextPicker

@synthesize title = _title;
@synthesize defaultValue = _defaultValue;
@synthesize itemList = _itemList;
@synthesize delaysCommit = _delaysCommit;

- (instancetype)initWithTitle:(NSString *)title itemList:(NSArray<NSString *> *)itemList {
  self = [super init];
  if (self) {
    _title = title;
    _itemList = itemList;
    _delaysCommit = NO;
  }
  return self;
}

+ (instancetype)controlWithTitle:(NSString *)title itemList:(NSArray<NSString *> *)itemList {
  return [[[self class] alloc] initWithTitle:title itemList:itemList];
}

- (RMXModelType)modelType {
  return kRMXModelTypeTextPicker;
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [NSMutableDictionary dictionary];
  json[@"controlType"] = @"__RemixControlTypeTextPicker__";
  json[@"title"] = self.title;
  json[@"defaultValue"] = self.defaultValue;
  json[@"itemList"] = self.itemList;
  return json;
}

@end
