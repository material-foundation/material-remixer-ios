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

#import "RMXBooleanRemix.h"
#import "RMXItemListRemix.h"
#import "RMXRangeRemix.h"

@implementation UIView (RMXRemixerAPI)

- (CGFloat)alphaRemixForKey:(NSString *)key updateProperty:(NSString *)property {
  return [self floatRemixForKey:key minValue:0 maxValue:1 updateProperty:property];
}

- (BOOL)booleanRemixForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXBooleanRemix addBooleanRemixWithKey:key
                             defaultValue:[self valueForKey:property]
                              updateBlock:^(RMXRemix *remix, BOOL selectedValue) {
                                [self setValue:@(selectedValue) forKey:property];
                              }];
  return [[self valueForKey:property] boolValue];
}

- (UIColor *)colorRemixForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXItemListRemix addItemListRemixWithKey:key
                               defaultValue:[self valueForKey:property]
                                   itemList:@[[UIColor redColor], [UIColor yellowColor]]
                                updateBlock:^(RMXRemix *_Nonnull remix, id _Nonnull selectedValue) {
                                  [self setValue:selectedValue forKey:property];
                                }];
  return [self valueForKey:property];
}

- (CGFloat)layoutRemixForKey:(NSString *)key updateProperty:(NSString *)property {
  [RMXRangeRemix addRangeRemixWithKey:key
                         defaultValue:[[self valueForKey:property] floatValue]
                             minValue:0
                             maxValue:CGFLOAT_MAX
                            increment:8
                          updateBlock:^(RMXRemix * _Nonnull remix, CGFloat selectedValue) {
                            [self setValue:@(selectedValue) forKey:property];
                            [self setNeedsLayout];
                          }];
  return [[self valueForKey:property] floatValue];
}

#pragma mark - Private

- (CGFloat)floatRemixForKey:(NSString *)key
                   minValue:(CGFloat)minValue
                   maxValue:(CGFloat)maxValue
             updateProperty:(NSString *)property {
  return [self floatRemixForKey:key
                       minValue:minValue
                       maxValue:maxValue
                      increment:0
                 updateProperty:property];
}

- (CGFloat)floatRemixForKey:(NSString *)key
                   minValue:(CGFloat)minValue
                   maxValue:(CGFloat)maxValue
                  increment:(CGFloat)increment
             updateProperty:(NSString *)property {
  [RMXRangeRemix addRangeRemixWithKey:key
                         defaultValue:[[self valueForKey:property] floatValue]
                             minValue:minValue
                             maxValue:maxValue
                            increment:increment
                          updateBlock:^(RMXRemix * _Nonnull remix, CGFloat selectedValue) {
                            [self setValue:@(selectedValue) forKey:property];
                          }];
  return [[self valueForKey:property] floatValue];
}

@end
