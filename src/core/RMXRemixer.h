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

NS_ASSUME_NONNULL_BEGIN

/**
 The RMXRemixer class is a Singleton class that keeps track of all the Variables and deals with
 saving/syncing its values.
 */
@interface RMXRemixer : NSObject

/**
 To be called from the AppDelegate to let Remixer know that the app has already set up the main window.
 Here we add the overlay and the gestures to trigger it.
 */
+ (void)attachToKeyWindow;

/**
 To be called from the AppDelegate to let Remixer know that the became active.
 Here we start communicating with Remote Controllers (if enabled).
 */
+ (void)applicationDidBecomeActive;

/**
 To be called from the AppDelegate to let Remixer know that the app will be backgrounded or closed.
 Here we clean up the data stored for Remote Controllers (if enabled).
 */
+ (void)applicationWillResignActive;

/**
 Opens the control panel overlay.
 */
+ (void)openPanel;

@end

NS_ASSUME_NONNULL_END
