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

/** Whether Remixer should be sharing or not. This is set by the user through the overlay UI. */
@property(nonatomic, assign, getter=isSharing) BOOL sharing;

/**
 Called when Remixer is ready to start receiving updates from remote controllers (for example, when
 the app comes back from the background). This does not set sharing to YES, and won't do anything
 if it's set to NO.
 */
- (void)restartConnection;

/**
 Called when Remixer wants to stop receiving updates from remote controllers (for example, when
 the app goes into the background).
 */
- (void)pauseConnection;

/** Refreshes the content that is displayed in the remote controller */
- (void)reloadData;

/** Adds a variable to the remote controllers */
- (void)addVariable:(RMXVariable *)variable;

/** Updates a variable in the remote controllers */
- (void)updateVariable:(RMXVariable *)variable;

/** Removes a variable from the remote controllers */
- (void)removeVariable:(RMXVariable *)variable;

/** Removes all variables from the remote controllers */
- (void)removeAllVariables;

/** The URL of the remote controller */
- (NSURL *)remoteControllerURL;

@end

NS_ASSUME_NONNULL_END
