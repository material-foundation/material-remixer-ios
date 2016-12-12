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

@class RMXVariable;

NS_ASSUME_NONNULL_BEGIN

/** Interface for the different types of remote controllers supported by Remixer */
@protocol RMXRemoteController <NSObject>

@required

/** Called when Remixer is ready to start receiving updates from remote controllers */
- (void)startObservingUpdates;

/** Called when Remixer wants to stop receiving updates from remote controllers */
- (void)stopObservingUpdates;

/** Adds a variable to the remote controllers */
- (void)addVariable:(RMXVariable *)variable;

/** Updates a variable in the remote controllers */
- (void)updateVariable:(RMXVariable *)variable;

/** Removes a variable from the remote controllers */
- (void)removeVariable:(RMXVariable *)variable;

/** Removes all variables from the remote controllers */
- (void)removeAllVariables;

@end

NS_ASSUME_NONNULL_END
