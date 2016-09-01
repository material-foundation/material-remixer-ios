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

#import "RMXRemixDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The RMXApp class provides a singleton implementation with an interface to start and stop a
 Remixer session.
 */
@interface RMXApp : NSObject <RMXRemixDelegate>

/** A unique session id. */
@property(nonatomic, readonly) NSString *sessionId;

/** The shared instance of this singleton. */
+ (instancetype)sharedInstance;

/** Generates a prefilled mailto: URL string that gets opened in the native email application. */
+ (void)sendEmailInvite;

/** Starts a new session of Remixer. */
- (void)start;

/** Stops the current Remixer session. */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
