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

@class RMXRemix;

/** Interface for they different types of storage supported by Remixer. */
@protocol RMXStorageController

@required
/**
 Retrieves a saved Remix using its key.
 @return A Remix or nil if not found.
 */
- (nullable RMXRemix *)remixForKey:(NSString *)key;

/** Saves a Remix */
- (void)saveRemix:(RMXRemix *)remix;

@optional
/** Called during initialization to give the controller a chance to set itself up. */
- (void)setup;

/** Called by Remixer when it wants to start receiving updates (if supported). */
- (void)startObservingUpdates;

/** Called by Remixer when it wants to stop receiving updates (if supported). */
- (void)stopObservingUpdates;

/** Called when Remixer is shutting down. */
- (void)shutDown;

@end
