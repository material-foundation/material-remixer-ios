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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RMXRemix;

/** Delegate methods for adding and updating a remix. */
@protocol RMXRemixDelegate <NSObject>
@optional

/**
 A remix has been added.

 @param remix The remix that has been added.
 */
- (void)didAddRemix:(RMXRemix *)remix;

/**
 A remix has been removed.

 @param key The dictionary key of the remix that has been removed.
 */
- (void)didRemoveRemixWithKey:(NSString *)key;

/** All remixes have been removed. */
- (void)didRemoveAllRemixes;

/**
 A remix has been synced to cloud services.

 @param remix The remix that has been synced.
 */
- (void)syncRemix:(RMXRemix *)remix;

/**
 A new value will be selected for a given remix.

 @param remix The remix that will be updated.
 @param selectedValue The new selected value for the given remix.
 */
- (void)remix:(RMXRemix *)remix willSelectValue:(NSNumber *)selectedValue;

/**
 A new value has been selected for a given remix.

 @param remix The remix that has been be updated.
 @param selectedValue The new selected value for the given remix.
 */
- (void)remix:(RMXRemix *)remix didSelectValue:(NSNumber *)selectedValue;

@end

NS_ASSUME_NONNULL_END
