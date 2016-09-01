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

#import "RMXRemix.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The RMXFirebaseHost class provides a singleton implementation with an interface to sync remix
 data with Firebase cloud services.
 */
@interface RMXFirebaseHost : NSObject

/** The shared instance of this singleton. */
+ (instancetype)sharedInstance;

/** Starts a new session of Firebase. */
- (void)start;

/** Stops the current Firebase session. */
- (void)stop;

/**
 Saves a remix to Firebase.

 The remix model will get transformed to JSON and saved within the Firebase datastore.

 @param remix The remix to be saved.
 */
- (void)saveRemix:(RMXRemix *)remix;

/**
 Removes a remix from Firebase stored with the given key at the current session.

 @param key The remix key stored in Firebase.
 */
- (void)removeRemixWithKey:(NSString *)key;

/** Removes all remixes from Firebase stored in the currecnt session. */
- (void)removeAllRemixes;

@end

NS_ASSUME_NONNULL_END
