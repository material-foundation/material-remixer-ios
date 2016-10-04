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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Category for UIView that adds a convenience API for Remixer. */
@interface UIView (RMXRemixerAPI)

/**
 Creates a RangeVariable with minValue 0 and maxValue 1.
 It automatically updates the view's property when the selectedValue changes.

 @return The current value of the property.
 */
- (CGFloat)alphaVariableForKey:(NSString *)key updateProperty:(NSString *)property;

/**
 Creates a BooleanVariable.
 It automatically updates the object's property when the selectedValue changes.
 
 @return The current value of the property.
 */
- (BOOL)booleanVariableForKey:(NSString *)key updateProperty:(NSString *)property;

/**
 Creates an ItemListVariable using the app's color palette as options.
 It automatically updates the view's property when the selectedValue changes.

 @return The current value of the property.
 */
- (nullable UIColor *)colorVariableForKey:(NSString *)key updateProperty:(NSString *)property;

/**
 Creates a RangeVariable with minValue 0 and maxValue a multiple of the app's grid size.
 It also sets the increment to the app's grid size so that everything aligns with it.
 It automatically updates the view's property when the selectedValue changes, and calls
 |setNeedsLayout|.

 @return The current value of the property.
 */
- (CGFloat)layoutVariableForKey:(NSString *)key updateProperty:(NSString *)property;

@end

NS_ASSUME_NONNULL_END
