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

#import "RMXColorVariable.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIColor.h>

#import "RMXRemixer.h"

NSString *const RMXColorKeyRed = @"r";
NSString *const RMXColorKeyGreen = @"g";
NSString *const RMXColorKeyBlue = @"b";
NSString *const RMXColorKeyAlpha = @"a";

@implementation RMXColorVariable

@dynamic selectedValue;

+ (instancetype)addColorVariableWithKey:(NSString *)key
                           defaultValue:(UIColor *)defaultValue
                         possibleValues:(NSArray<UIColor *> *)possibleValues
                            updateBlock:(RMXColorUpdateBlock)updateBlock {
  RMXColorVariable *variable =
      [[self alloc] initWithKey:key defaultValue:defaultValue updateBlock:updateBlock];
  variable.possibleValues = possibleValues;
  [RMXRemixer addVariable:variable];
  return variable;
}

+ (instancetype)variableFromDictionary:(NSDictionary *)dictionary {
  id selectedValue = [dictionary objectForKey:RMXDictionaryKeySelectedValue];
  selectedValue = [self colorFromRGBADictionary:selectedValue];
  return [[self alloc] initWithKey:[dictionary objectForKey:RMXDictionaryKeyKey]
                      defaultValue:selectedValue
                       updateBlock:nil];
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = [self rgbaDictionaryFromColor:self.selectedValue];
  if (self.possibleValues.count > 0) {
    json[RMXDictionaryKeyItemList] = [self colorsToJSON];
  }
  return json;
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(UIColor *)defaultValue
                updateBlock:(RMXColorUpdateBlock)updateBlock {
  self = [super initWithKey:key
             typeIdentifier:RMXTypeColor
               defaultValue:defaultValue
                updateBlock:updateBlock];
  self.possibleValues = [NSArray array];
  self.controlType = RMXControlTypeColorPicker;
  return self;
}

- (NSArray *)colorsToJSON {
  NSMutableArray<NSDictionary *> *rgbaColors = [NSMutableArray array];
  for (UIColor *color in self.possibleValues) {
    [rgbaColors addObject:[[self class] rgbaDictionaryFromColor:color]];
  }
  return rgbaColors;
}

- (NSDictionary *)rgbaDictionaryFromColor:(UIColor *)color {
  CGFloat r, g, b, a;
  if (![color getRed:&r green:&g blue:&b alpha:&a]) {
    [color getWhite:&r alpha:&a];
    g = b = r;
  };
  return @{
    RMXColorKeyRed : @(round(r * 255)),
    RMXColorKeyGreen : @(round(g * 255)),
    RMXColorKeyBlue : @(round(b * 255)),
    RMXColorKeyAlpha : @(a)
  };
}

+ (UIColor *)colorFromRGBADictionary:(NSDictionary *)dictionary {
  CGFloat red = [[dictionary objectForKey:RMXColorKeyRed] integerValue] / 255.0;
  CGFloat green = [[dictionary objectForKey:RMXColorKeyGreen] integerValue] / 255.0;
  CGFloat blue = [[dictionary objectForKey:RMXColorKeyBlue] integerValue] / 255.0;
  CGFloat alpha = [[dictionary objectForKey:RMXColorKeyAlpha] floatValue];
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
