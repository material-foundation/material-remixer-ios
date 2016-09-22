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

#import "RMXRemixConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class RMXRemix;

/** Delegate for receiving updates when the value of this Remix changes. */
@protocol RMXRemixDelegate <NSObject>

/** Method that gets called when the value gets updated by the user using the overlay. */
- (void)remix:(RMXRemix *)remix wasUpdatedFromOverlayToValue:(id)value;

/** Method that gets called when the value gets updated from outside of the app. */
- (void)remix:(RMXRemix *)remix wasUpdatedFromBackendToValue:(id)value;

@end

/** RMXUpdateBlock is a block that will be invoked when a remix is updated. */
typedef void (^RMXUpdateBlock)(RMXRemix *remix, id selectedValue);

/**
 The RMXRemix class provides the core infrastructure for creating different types of remixes.
 */
@interface RMXRemix : NSObject

/** The unique key of the remix. */
@property(nonatomic, readonly) NSString *key;

/** The selected value of a given remix. */
@property(nonatomic, readonly) id selectedValue;

/** The type of remix. See RMXRemixConstants for possible values. */
@property(nonatomic, readonly) NSString *typeIdentifier;

/** The update blocks associated with this remix. */
@property(nonatomic, readonly) NSArray *updateBlocks;

/** The title associated with this remix. The default value is the remixer's key. */
@property(nonatomic, copy) NSString *title;

/** The type of control to be used in the in-app overlay. */
@property(nonatomic, assign) RMXControlType controlType;

/** Flag used to prevent storing/syncing values during continuous UI updates. */
@property(nonatomic, assign) BOOL delaysCommits;

/** The delegate for this remix. */
// TODO(chuga): Make this an array.
@property(nonatomic, weak) id<RMXRemixDelegate> delegate;

/** Designated initializer. */
- (instancetype)initWithKey:(NSString *)key
             typeIdentifier:(NSString *)typeIdentifier
               defaultValue:(nullable id)defaultValue
                updateBlock:(RMXUpdateBlock)updateBlock;

/** Creates an instance based on the data contained in a dictionary. */
+ (instancetype)remixFromDictionary:(NSDictionary *)dictionary;

/** Setter for the selectedValue property. */
- (void)setSelectedValue:(id)value fromOverlay:(BOOL)fromOverlay;

/** Executes all the update blocks with the current selected value. */
- (void)executeUpdateBlocks;

/** Adds a new update block and executes it with the current selected value. */
- (void)addAndExecuteUpdateBlock:(RMXUpdateBlock)updateBlock;

/** The dictionary json represenation of this object. */
- (NSMutableDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
