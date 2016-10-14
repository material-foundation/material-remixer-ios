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

/** Identifiers for the different types of Variables. */
static NSString *const RMXTypeItemList = @"__VariableTypeItemList__";
static NSString *const RMXTypeBoolean = @"__VariableTypeBoolean__";
static NSString *const RMXTypeColor = @"__VariableTypeColor__";
static NSString *const RMXTypeRange = @"__VariableTypeRange__";
static NSString *const RMXTypeString = @"__VariableTypeString__";

/** Keys for the JSON dictionary that contains the data for a Variable. */
static NSString *const RMXDictionaryKeyKey = @"key";
static NSString *const RMXDictionaryKeySelectedValue = @"selectedValue";
static NSString *const RMXDictionaryKeyPossibleValues = @"possibleValues";
static NSString *const RMXDictionaryKeyTypeIdentifier = @"typeIdentifier";
static NSString *const RMXDictionaryKeyControlType = @"controlType";
static NSString *const RMXDictionaryKeyTitle = @"title";
static NSString *const RMXDictionaryKeyMinValue = @"minimumValue";
static NSString *const RMXDictionaryKeyMaxValue = @"maximumValue";
static NSString *const RMXDictionaryKeyIncrement = @"increment";

/** Type of UI controls supported by Remixer. */
typedef NS_ENUM(NSInteger, RMXControlType) {
  RMXControlTypeButton = 0,
  RMXControlTypeColorList = 1,
  RMXControlTypeColorPicker = 2,
  RMXControlTypeSegmented = 3,
  RMXControlTypeSlider = 4,
  RMXControlTypeStepper = 5,
  RMXControlTypeSwitch = 6,
  RMXControlTypeTextPicker = 7
};
