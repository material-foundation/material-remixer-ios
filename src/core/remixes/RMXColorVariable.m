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
@dynamic limitedToValues;

+ (instancetype)colorVariableWithKey:(NSString *)key
                        defaultValue:(UIColor *)defaultValue
                     limitedToValues:(NSArray<UIColor *> *)limitedToValues
                         updateBlock:(nullable RMXColorUpdateBlock)updateBlock {
  RMXVariable *existingVariable = [RMXRemixer variableForKey:key];
  if (existingVariable) {
    [existingVariable addAndExecuteUpdateBlock:^(RMXVariable *variable, id selectedValue) {
      if (updateBlock) {
        updateBlock((RMXColorVariable *)variable, selectedValue);
      }
    }];
    return (RMXColorVariable *)existingVariable;
  } else {
    RMXColorVariable *variable = [[self alloc] initWithKey:key
                                              defaultValue:defaultValue
                                           limitedToValues:limitedToValues
                                               updateBlock:updateBlock];
    [RMXRemixer addVariable:variable];
    return variable;
  }
}

- (NSDictionary *)toJSON {
  NSMutableDictionary *json = [super toJSON];
  json[RMXDictionaryKeySelectedValue] = [[self class] rgbaDictionaryFromColor:self.selectedValue];
  if (self.limitedToValues.count > 0) {
    json[RMXDictionaryKeyLimitedToValues] = [self colorsToJSON];
  }
  return json;
}

- (void)setSelectedValue:(id)selectedValue {
  if ([selectedValue isKindOfClass:[NSDictionary class]]) {
    selectedValue = [[self class] colorFromRGBADictionary:selectedValue];
  }
  [super setSelectedValue:selectedValue];
}

#pragma mark - Private

- (instancetype)initWithKey:(NSString *)key
               defaultValue:(UIColor *)defaultValue
            limitedToValues:(NSArray<UIColor *> *)limitedToValues
                updateBlock:(RMXColorUpdateBlock)updateBlock {
  self = [super initWithKey:key
                   dataType:RMXDataTypeColor
               defaultValue:defaultValue
                updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                  if (updateBlock) {
                    updateBlock((RMXColorVariable *)variable, selectedValue);
                  }
                }];
  self.limitedToValues = limitedToValues;
  // TODO(chuga): Implement a color picker control for color variables that don't have a pre-defined
  // list of possible values.
  self.controlType =
      self.limitedToValues.count > 0 ? RMXControlTypeColorList : RMXControlTypeColorInput;
  return self;
}

- (NSArray *)colorsToJSON {
  NSMutableArray<NSDictionary *> *rgbaColors = [NSMutableArray array];
  for (UIColor *color in self.limitedToValues) {
    [rgbaColors addObject:[[self class] rgbaDictionaryFromColor:color]];
  }
  return rgbaColors;
}

+ (NSDictionary *)rgbaDictionaryFromColor:(UIColor *)color {
  CGFloat r, g, b, a;
  if (![color getRed:&r green:&g blue:&b alpha:&a]) {
    [color getWhite:&r alpha:&a];
    g = b = r;
  };
  return @{
    RMXColorKeyRed : @(round(r * 255)),
    RMXColorKeyGreen : @(round(g * 255)),
    RMXColorKeyBlue : @(round(b * 255)),
    RMXColorKeyAlpha : @(round(a * 255))
  };
}

+ (UIColor *)colorFromRGBADictionary:(NSDictionary *)dictionary {
  CGFloat red = [[dictionary objectForKey:RMXColorKeyRed] integerValue] / 255.0;
  CGFloat green = [[dictionary objectForKey:RMXColorKeyGreen] integerValue] / 255.0;
  CGFloat blue = [[dictionary objectForKey:RMXColorKeyBlue] integerValue] / 255.0;
  CGFloat alpha = [[dictionary objectForKey:RMXColorKeyAlpha] integerValue] / 255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
