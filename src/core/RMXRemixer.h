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

#import "RMXVariable.h"

@class RMXOverlayWindow;

typedef NS_ENUM(NSInteger, RMXStorageMode) { RMXStorageModeLocal = 0, RMXStorageModeCloud = 1 };

NS_ASSUME_NONNULL_BEGIN

/**
 The RMXRemixer class is a Singleton class that keeps track of all the Variables and deals with
 saving/syncing its values.
 */
@interface RMXRemixer : NSObject

/** Starts Remixer */
+ (void)startInMode:(RMXStorageMode)mode;

/** Stops the current Remixer session. */
+ (void)stop;

/** Sends an invitation to the web dashboard. */
+ (void)sendEmailInvite;

/** A unique session id. */
+ (NSString *)sessionId;

/**
 Getter for the UIWindow used by the overlay.
 @return The UIWindow.
 */
+ (RMXOverlayWindow *)overlayWindow;

/**
 Returns a Variable with the given key from the dictionary of Variables.
 @param key The key of the Variable.
 @return A Variable from the dictionary of Variables.
 */
+ (nullable RMXVariable *)variableForKey:(NSString *)key;

/**
 Adds a Variable to the dictionary of Variables stored by key.
 @param variable The Variable to be added.
 */
+ (__kindof RMXVariable *)addVariable:(RMXVariable *)variable;

/**
 Removes a Variable from the dictionary of Variables.
 @param variable The Variable to be removed.
 */
+ (void)removeVariable:(RMXVariable *)variable;

/**
 Removes a Variable with the given key from the dictionary of Variables.
 @param key The dictionary key of the Variable.
 */
+ (void)removeVariableWithKey:(NSString *)key;

/**
 Returns all Variables.
 @return An array of all current Variables.
 */
+ (NSArray<RMXVariable *> *)allVariables;

/** Removes all Variables and empties the dictionary of Variables. */
+ (void)removeAllVariables;

/** Saves the Variable using one of the storage options. */
+ (void)saveVariable:(RMXVariable *)variable;

/** Update an existing Variable using a version from one of our storage sources. */
+ (void)updateVariable:(RMXVariable *)variable usingStoredVariable:(RMXVariable *)storedVariable;

@end

NS_ASSUME_NONNULL_END
