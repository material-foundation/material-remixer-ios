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

#import "RMXColorPicker.h"

@implementation RMXColorPicker

@synthesize title;
@synthesize defaultValue;
@synthesize itemList;
@synthesize delaysCommit;

- (instancetype)initWithTitle:(NSString *)title itemList:(NSArray<UIColor *> *)itemList {
  self = [super init];
  if (self) {
    self.title = title;
    self.itemList = itemList;
    self.delaysCommit = NO;
  }
  return self;
}

+ (instancetype)controlWithTitle:(NSString *)title itemList:(NSArray<UIColor *> *)itemList {
  return [[[self class] alloc] initWithTitle:title itemList:itemList];
}

- (RMXModelType)modelType {
  return kRMXModelTypeColorPicker;
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [NSMutableDictionary dictionary];
  json[@"controlType"] = @"__RemixControlTypeColorPicker__";
  json[@"title"] = self.title;
  json[@"defaultValue"] = self.defaultValue;

  NSMutableArray<NSDictionary *> *hexColors = [NSMutableArray array];
  for (UIColor *color in self.itemList) {
    [hexColors addObject:[self rgbaDictionaryFromColor:color]];
  }
  json[@"itemList"] = hexColors;
  return json;
}

- (NSDictionary *)rgbaDictionaryFromColor:(UIColor *)color {
  CGFloat r, g, b, a;
  if (![color getRed:&r green:&g blue:&b alpha:&a]) {
    [color getWhite:&r alpha:&a];
    g = b = r;
  };
  return @{
    @"r" : @(round(r * 255)),
    @"g" : @(round(g * 255)),
    @"b" : @(round(b * 255)),
    @"a" : @(a)
  };
}

@end
