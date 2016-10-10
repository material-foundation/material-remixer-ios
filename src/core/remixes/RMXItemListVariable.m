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

#import "RMXItemListVariable.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIColor.h>

#import "RMXRemixer.h"

NSString *const kColorKeyRed = @"r";
NSString *const kColorKeyGreen = @"g";
NSString *const kColorKeyBlue = @"b";
NSString *const kColorKeyAlpha = @"a";

@implementation RMXItemListVariable

+ (instancetype)addItemListVariableWithKey:(NSString *)key
                              defaultValue:(id)defaultValue
                                  itemList:(NSArray<id> *)itemList
                               updateBlock:(RMXUpdateBlock)updateBlock {
  RMXItemListVariable *variable = [[self alloc] initItemListVariableWithKey:key
                                                               defaultValue:defaultValue
                                                                   itemList:itemList
                                                                updateBlock:updateBlock];
  [RMXRemixer addVariable:variable];
  return variable;
}

+ (instancetype)variableFromDictionary:(NSDictionary *)dictionary {
  id selectedValue = [dictionary objectForKey:RMXDictionaryKeySelectedValue];
  NSMutableArray *itemList = [NSMutableArray array];
  if ([selectedValue isKindOfClass:[NSDictionary class]]) {
    selectedValue = [self colorFromRGBADictionary:selectedValue];
    for (NSDictionary *colorDictionary in [dictionary objectForKey:RMXDictionaryKeyItemList]) {
      [itemList addObject:[self colorFromRGBADictionary:colorDictionary]];
    }
  } else {
    itemList = [dictionary objectForKey:RMXDictionaryKeyItemList];
  }
  return [[self alloc] initItemListVariableWithKey:[dictionary objectForKey:RMXDictionaryKeyKey]
                                      defaultValue:selectedValue
                                          itemList:itemList
                                       updateBlock:nil];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  if ([self.selectedValue isKindOfClass:[UIColor class]]) {
    json[RMXDictionaryKeySelectedValue] = [[self class] rgbaDictionaryFromColor:self.selectedValue];
    json[RMXDictionaryKeyItemList] = [self colorsToJSON];
  } else {
    json[RMXDictionaryKeySelectedValue] = self.selectedValue;
    json[RMXDictionaryKeyItemList] = self.itemList;
  }
  return json;
}

- (void)setSelectedValue:(id)selectedValue {
  // TODO(chuga): Improve this.
  if ([selectedValue isKindOfClass:[NSDictionary class]]) {
    selectedValue = [[self class] colorFromRGBADictionary:selectedValue];
  }
  [super setSelectedValue:selectedValue];
}

#pragma mark - Private

- (instancetype)initItemListVariableWithKey:(NSString *)key
                               defaultValue:(id)defaultValue
                                   itemList:(NSArray<id> *)itemList
                                updateBlock:(RMXUpdateBlock)updateBlock {
  self = [super initWithKey:key
             typeIdentifier:RMXTypeItemList
               defaultValue:defaultValue
                updateBlock:updateBlock];
  if (self) {
    _itemList = itemList;
    self.controlType = [_itemList.firstObject isKindOfClass:[UIColor class]]
                           ? RMXControlTypeColorList
                           : RMXControlTypeTextPicker;
  }
  return self;
}

- (instancetype)initItemListVariableWithKey:(NSString *)key
                                   itemList:(NSArray<id> *)itemList
                                updateBlock:(RMXUpdateBlock)updateBlock {
  self = [self initItemListVariableWithKey:key
                              defaultValue:nil
                                  itemList:itemList
                               updateBlock:updateBlock];
  return self;
}

#pragma mark - UIColor helpers

- (NSArray *)colorsToJSON {
  NSMutableArray<NSDictionary *> *hexColors = [NSMutableArray array];
  for (UIColor *color in self.itemList) {
    [hexColors addObject:[[self class] rgbaDictionaryFromColor:color]];
  }
  return hexColors;
}

+ (NSDictionary *)rgbaDictionaryFromColor:(UIColor *)color {
  CGFloat r, g, b, a;
  if (![color getRed:&r green:&g blue:&b alpha:&a]) {
    [color getWhite:&r alpha:&a];
    g = b = r;
  };
  return @{
    kColorKeyRed : @(round(r * 255)),
    kColorKeyGreen : @(round(g * 255)),
    kColorKeyBlue : @(round(b * 255)),
    kColorKeyAlpha : @(a)
  };
}

+ (UIColor *)colorFromRGBADictionary:(NSDictionary *)dictionary {
  CGFloat red = [[dictionary objectForKey:kColorKeyRed] integerValue] / 255.0;
  CGFloat green = [[dictionary objectForKey:kColorKeyGreen] integerValue] / 255.0;
  CGFloat blue = [[dictionary objectForKey:kColorKeyBlue] integerValue] / 255.0;
  CGFloat alpha = [[dictionary objectForKey:kColorKeyAlpha] floatValue];
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
