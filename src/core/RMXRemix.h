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

#import "RMXModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RMXRemix;
@protocol RMXRemixDelegate;

/** RMXUpdateBlock is a block that will be invoked when a remix control is updated. */
typedef void (^RMXUpdateBlock)(RMXRemix *remix, NSNumber *_Nullable selectedValue);

/**
 The RMXRemix class provides an interface to create and store confgurable remixes for the app.
 */
@interface RMXRemix : NSObject

/** The unique key of the remix. */
@property(nonatomic, readonly) NSString *key;

/** The remix model. */
@property(nonatomic, readonly) id<RMXModel> model;

/** Provides a RMXRemixDelegate protocol reference to the RMXApp. */
@property(nonatomic, weak) id<RMXRemixDelegate> appDelegate;

/** Provides a RMXRemixDelegate protocol reference to the specific cell for an individual remix. */
@property(nonatomic, weak) id<RMXRemixDelegate> cellDelegate;

/** Whether the remix has been synced to cloud services. */
@property(nonatomic, assign) BOOL isSynced;

/** The selected value of a given remix. */
@property(nonatomic, strong) NSNumber *selectedValue;

#pragma mark - Adding

/**
 Adds a remix to the dictionary of remixes stored by key.

 @param key The unique key stored with the remix.
 @param control The control to display in the overlay for the remix.
 @param selectedValue The initial selected value for the remix.
 @param updateBlock A block to execute when the remix selected value gets updated.
 @return An initialized RMXRemix object.
 */
+ (instancetype)addRemixWithKey:(NSString *)key
                   usingControl:(id<RMXModel>)control
                  selectedValue:(NSNumber *)selectedValue
                    updateBlock:(RMXUpdateBlock)updateBlock;

#pragma mark - Updating

/**
 Updates a remix.

 @param selectedValue The updated selected value for the remix.
 @param remix The remix to apply the selected value to.
 @param shouldSync Whether this update should trigger a sync to cloud services.
 */
+ (void)updateSelectedValue:(NSNumber *)selectedValue
                   forRemix:(RMXRemix *)remix
                 shouldSync:(BOOL)shouldSync;

/**
 Sends a notification triggered from a remix button.

 @param key The dictionary key of the remix.
 */
+ (void)sendNotificationWithKey:(NSString *)key;

/** Restores all remixes to their default values. */
+ (void)restoreDefaults;

#pragma mark - Removing

/**
 Removes a remix with the given key from the dictionary of remixes.

 @param key The dictionary key of the remix.
 */
+ (void)removeRemixWithKey:(NSString *)key;

/** Removes all remixes and empties the dictionary of remixes. */
+ (void)removeAllRemixes;

#pragma mark - Querying

/**
 Returns all remixes.

 @return An array of all current remixes.
 */
+ (NSArray<RMXRemix *> *)allRemixes;

/**
 Returns a remix with the given key from the dictionary of remixes.

 @param key The dictionary key of the remix.
 @return A remix from the dictionary of remixes.
 */
+ (RMXRemix *)remixForKey:(NSString *)key;

#pragma mark - Storage

/**
 Returns a saved selected value from standardUserDefaults for given remix key.

 @param key The dictionary key of the remix.
 @return The selected value saved at this key.
 */
- (id)savedValueForKey:(NSString *)key;

/** Stores the remix locally to standardUserDefaults. */
- (void)commit;

#pragma mark - Syncing

/** Syncs the remix to cloud services. */
- (void)sync;

@end

NS_ASSUME_NONNULL_END
