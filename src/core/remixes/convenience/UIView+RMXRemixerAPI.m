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

#import "UIView+RMXRemixerAPI.h"

#import "RMXItemListVariable.h"
#import "RMXRangeVariable.h"

// TODO(chuga): Make these configurable.
static CGFloat kGridSize = 8.0f;
static CGFloat kPaddingMaxGridMultiplier = 20;

@implementation UIView (RMXRemixerAPI)

- (CGFloat)alphaVariableForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXRangeVariable
      addRangeVariableWithKey:key
                 defaultValue:[[self valueForKey:property] floatValue]
                     minValue:0
                     maxValue:1
                    increment:0
                  updateBlock:^(RMXVariable *_Nonnull variable, CGFloat selectedValue) {
                    [self setValue:@(selectedValue) forKey:property];
                  }];
  return [[self valueForKey:property] floatValue];
}

- (UIColor *)colorVariableForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXItemListVariable
      addItemListVariableWithKey:key
                    defaultValue:[self valueForKey:property]
                        itemList:[self colorPalette]
                     updateBlock:^(RMXVariable *_Nonnull variable, id _Nonnull selectedValue) {
                       [self setValue:selectedValue forKey:property];
                     }];
  return [self valueForKey:property];
}

- (CGFloat)layoutVariableForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXRangeVariable
      addRangeVariableWithKey:key
                 defaultValue:[[self valueForKey:property] floatValue]
                     minValue:0
                     maxValue:kGridSize * kPaddingMaxGridMultiplier
                    increment:kGridSize
                  updateBlock:^(RMXVariable *_Nonnull variable, CGFloat selectedValue) {
                    [self setValue:@(selectedValue) forKey:property];
                    [self setNeedsLayout];
                  }];
  return [[self valueForKey:property] floatValue];
}

#pragma mark - Private

// Temporary hack to fake a color palette. This will go away once we support color palettes.
- (NSArray<UIColor *> *)colorPalette {
  return @[ [UIColor redColor], [UIColor yellowColor] ];
}

@end
