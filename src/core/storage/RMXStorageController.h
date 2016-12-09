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

/** Interface for the different types of storage options supported by Remixer. */
@protocol RMXStorageController <NSObject>

@required

/**
 Retrieves the saved value for a variable's key
 @param key The variable's key
 */
- (nullable id)selectedValueForVariableKey:(NSString *)key;

/**
 Saves the selected value of the variable
 @param variable The variable whos selected value we want to save
 */
- (void)saveSelectedValueOfVariable:(RMXVariable *)variable;

@end

NS_ASSUME_NONNULL_END
