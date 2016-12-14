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

#import "RMXVariableConstants.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const RMXVariableUpdateNotification = @"RMXVariableUpdateNotification";

@class RMXVariable;

/** RMXUpdateBlock is a block that will be invoked when a Variable is updated. */
typedef void (^RMXUpdateBlock)(RMXVariable *variable, id selectedValue);

/**
 This class provides the core infrastructure for creating different types of Variables.
 You can subscribe to RMXRemixUpdateNotification if you want to be notified of any changes to
 the selectedValue property.
 */
@interface RMXVariable : NSObject

/** The unique key of the Variable. */
@property(nonatomic, readonly) NSString *key;

/** The selected value of a given Variable. */
@property(nonatomic, strong) id selectedValue;

/** If set, these are the only values this Variable can take. */
@property(nonatomic, strong) NSArray<id> *possibleValues;

/** The type of data this Variable holds. See RMXRemixConstants for possible values. */
@property(nonatomic, readonly) NSString *dataType;

/** The update blocks associated with this Variable. */
@property(nonatomic, readonly) NSArray *updateBlocks;

/** The title associated with this Variable. The default value is the Variable's key. */
@property(nonatomic, copy) NSString *title;

/** The type of control to be used in the in-app overlay. */
@property(nonatomic, assign) NSString *controlType;

/** Designated initializer. */
- (instancetype)initWithKey:(NSString *)key
                   dataType:(NSString *)dataType
               defaultValue:(nullable id)defaultValue
                updateBlock:(nullable RMXUpdateBlock)updateBlock;

/** Saves the current value of the Variable. */
- (void)save;

/** Executes all the update blocks with the current selected value. */
- (void)executeUpdateBlocks;

/** Adds a new update block and executes it with the current selected value. */
- (void)addAndExecuteUpdateBlock:(RMXUpdateBlock)updateBlock;

/** The dictionary json represenation of this object. */
- (NSMutableDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
