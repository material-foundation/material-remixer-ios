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

/** Delegate for receiving updates when the value of this Remix changes. */
@protocol RMXRemixDelegate <NSObject>

/** Method that gets called when the value gets updated by the user using the overlay. */
- (void)remix:(RMXRemix *)remix wasUpdatedFromOverlayToValue:(id)value;

/** Method that gets called when the value gets updated from outside of the app. */
- (void)remix:(RMXRemix *)remix wasUpdatedFromBackendToValue:(id)value;

@end

/** Identifiers for the different types of Remixes. */
static NSString *const RMXTypeItemList = @"__RemixTypeItemList__";
static NSString *const RMXTypeBoolean = @"__RemixTypeBoolean__";
static NSString *const RMXTypeRange = @"__RemixTypeRange__";
static NSString *const RMXTypeString = @"__RemixTypeString__";

/** Keys for the JSON dictionary that contains the data for a Remix. */
static NSString *const RMXDictionaryKeySelectedValue = @"selectedValue";
static NSString *const RMXDictionaryKeyKey = @"key";
static NSString *const RMXDictionaryKeyTypeIdentifier = @"typeIdentifier";
static NSString *const RMXDictionaryKeyControlType = @"controlType";
static NSString *const RMXDictionaryKeyTitle = @"title";
static NSString *const RMXDictionaryKeyMinValue = @"minimumValue";
static NSString *const RMXDictionaryKeyMaxValue = @"maximumValue";
static NSString *const RMXDictionaryKeyIncrement = @"increment";
static NSString *const RMXDictionaryKeyItemList = @"itemList";

/** Type of UI controls supported by Remixer. */
typedef NS_ENUM(NSInteger, RMXControlType) {
  RMXControlTypeButton = 0,
  RMXControlTypeColorPicker = 1,
  RMXControlTypeSegmented = 2,
  RMXControlTypeSlider = 3,
  RMXControlTypeStepper = 4,
  RMXControlTypeSwitch = 5,
  RMXControlTypeTextPicker = 6
};

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

/** The type of remix. */
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

/** Initializer for creating Remixes from a dictionary. */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

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
